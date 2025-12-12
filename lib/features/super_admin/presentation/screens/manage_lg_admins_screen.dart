import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/super_admin_bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/features/application/data/models/states_models.dart';
import 'package:algon_mobile/features/super_admin/data/repository/super_admin_repository.dart';
import 'package:algon_mobile/features/super_admin/data/models/invite_lg_admin_models.dart';
import 'package:algon_mobile/features/super_admin/data/models/lg_admin_list_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'ManageLGAdmins')
class ManageLGAdminsScreen extends ConsumerStatefulWidget {
  const ManageLGAdminsScreen({super.key});

  @override
  ConsumerState<ManageLGAdminsScreen> createState() =>
      _ManageLGAdminsScreenState();
}

class _ManageLGAdminsScreenState extends ConsumerState<ManageLGAdminsScreen> {
  final _searchController = TextEditingController();
  List<StateData> _states = [];
  List<LGAdminListItem> _lgAdmins = [];
  bool _isLoading = true;
  String _searchQuery = '';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _fetchStates();
    _fetchLGAdmins();

    // Listen to search changes with debounce
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _searchQuery) {
      _searchQuery = query;

      // Cancel previous timer
      _searchDebounce?.cancel();

      // Debounce search: wait 500ms after user stops typing
      _searchDebounce = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          _fetchLGAdmins();
        }
      });
    }
  }

  Future<void> _fetchStates() async {
    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final result = await applicationRepo.getAllStates();

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _states = response.data;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            if (error is ApiExceptions) {
              Toast.apiError(error, context);
            } else {
              Toast.error(error.toString(), context);
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        Toast.error('Failed to load states: ${e.toString()}', context);
      }
    }
  }

  Future<void> _fetchLGAdmins() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final superAdminRepo = ref.read(superAdminRepositoryProvider);
      final result = await superAdminRepo.getLGAdmins(
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _lgAdmins = response.data;
              _isLoading = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          // If 404, fallback to using states data to show all LGAs
          if (statusCode == 404) {
            _fetchLGAdminsFromStates();
            return;
          }

          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            if (error is ApiExceptions) {
              // Only show error if it's not a 404 (endpoint doesn't exist yet)
              if (statusCode != 404) {
                Toast.apiError(error, context);
              }
            } else {
              Toast.error(error.toString(), context);
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Toast.error('Failed to load LG admins: ${e.toString()}', context);
      }
    }
  }

  /// Fallback: Build LG Admin list from states data when endpoint doesn't exist
  void _fetchLGAdminsFromStates() {
    if (_states.isEmpty) {
      // Wait for states to load first
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _fetchLGAdminsFromStates();
        }
      });
      return;
    }

    final List<LGAdminListItem> lgAdminsList = [];

    for (final state in _states) {
      for (final lg in state.localGovernments) {
        // Filter by search query if provided
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final matchesLg = lg.name.toLowerCase().contains(query);
          final matchesState = state.name.toLowerCase().contains(query);

          if (!matchesLg && !matchesState) {
            continue;
          }
        }

        lgAdminsList.add(LGAdminListItem(
          id: lg.id,
          name: lg.name,
          state: state.name,
          stateId: state.id,
          localGovernment: lg.name,
          localGovernmentId: lg.id,
          adminName: null, // No admin data available yet
          adminEmail: null,
          adminId: null,
          applicationsCount: null,
          isActive: false, // Mark as inactive until we have real data
          createdAt: null,
          updatedAt: null,
        ));
      }
    }

    if (mounted) {
      setState(() {
        _lgAdmins = lgAdminsList;
        _isLoading = false;
      });
    }
  }

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (context) => _InviteLGAdminDialog(
        states: _states,
        onInvited: () {
          // Refresh the list after inviting
          _fetchLGAdmins();
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.router.maybePop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Manage LG Admins',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_lgAdmins.length} Local Government${_lgAdmins.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: CustomTextField(
                controller: _searchController,
                label: '',
                hint: 'Search LGA, state, or admin...',
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF9FAFB),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _lgAdmins.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inbox_outlined,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'No LG Admins found'
                                      : 'No results found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                    child: const Text('Clear search'),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchLGAdmins,
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                ..._lgAdmins.map((lgAdmin) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: _LGAdminCard(
                                        name: lgAdmin.localGovernment,
                                        state: lgAdmin.state,
                                        adminName: lgAdmin.adminName,
                                        applicationsCount:
                                            lgAdmin.applicationsCount,
                                        isActive: lgAdmin.isActive,
                                        onEdit: () {
                                          // TODO: Implement edit functionality
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SuperAdminBottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showInviteDialog,
        backgroundColor: AppColors.green,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Invite Admin',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _InviteLGAdminDialog extends ConsumerStatefulWidget {
  final List<StateData> states;
  final VoidCallback? onInvited;

  const _InviteLGAdminDialog({
    required this.states,
    this.onInvited,
  });

  @override
  ConsumerState<_InviteLGAdminDialog> createState() =>
      _InviteLGAdminDialogState();
}

class _InviteLGAdminDialogState extends ConsumerState<_InviteLGAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  StateData? _selectedState;
  LocalGovernment? _selectedLG;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  List<LocalGovernment> get _selectedLocalGovernments {
    if (_selectedState == null) return [];
    return _selectedState!.localGovernments;
  }

  Future<void> _inviteAdmin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      Toast.formError(context);
      return;
    }

    if (_selectedState == null || _selectedLG == null) {
      Toast.error('Please select both State and Local Government', context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final superAdminRepo = ref.read(superAdminRepositoryProvider);
      final request = InviteLGAdminRequest(
        state: _selectedState!.id,
        lga: _selectedLG!.id,
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
      );

      final result = await superAdminRepo.inviteLGAdmin(request);

      result.when(
        success: (response) {
          if (mounted) {
            Toast.success(response.message, context);
            Navigator.of(context).pop();
            widget.onInvited?.call();
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            if (error is ApiExceptions) {
              Toast.apiError(error, context);
            } else {
              Toast.error(error.toString(), context);
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        Toast.error('Failed to invite admin: ${e.toString()}', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Invite LG Admin',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  hint: 'Enter full name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'admin@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownField<StateData>(
                  label: 'State',
                  value: _selectedState,
                  items: widget.states,
                  hint: 'Select state',
                  itemBuilder: (state) => state.name,
                  validator: (value) {
                    if (value == null) {
                      return 'State is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                      _selectedLG = null;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownField<LocalGovernment>(
                  label: 'Local Government',
                  value: _selectedLG,
                  items: _selectedLocalGovernments,
                  hint: _selectedState == null
                      ? 'Select state first'
                      : 'Select Local Government',
                  itemBuilder: (lg) => lg.name,
                  validator: (value) {
                    if (value == null) {
                      return 'Local Government is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedLG = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        variant: ButtonVariant.outline,
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: _isLoading ? 'Inviting...' : 'Invite',
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _inviteAdmin,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LGAdminCard extends StatelessWidget {
  final String name;
  final String state;
  final String? adminName;
  final int? applicationsCount;
  final bool isActive;
  final VoidCallback onEdit;

  const _LGAdminCard({
    required this.name,
    required this.state,
    this.adminName,
    this.applicationsCount,
    required this.isActive,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (adminName != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Admin: $adminName',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
                if (applicationsCount != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Applications: $applicationsCount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFE8F5E3) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: isActive ? AppColors.green : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? AppColors.green : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
