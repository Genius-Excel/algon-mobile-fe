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

  @override
  void initState() {
    super.initState();
    _fetchStates();
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

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (context) => _InviteLGAdminDialog(
        states: _states,
      ),
    );
  }

  @override
  void dispose() {
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
                          '774 Local Governments',
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
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _LGAdminCard(
                      name: 'Ikeja',
                      state: 'Lagos State',
                      adminName: 'Abubakar Ibrahim',
                      applicationsCount: 185,
                      isActive: true,
                      onEdit: () {},
                    ),
                    const SizedBox(height: 12),
                    _LGAdminCard(
                      name: 'Owerri Municipal',
                      state: 'Imo State',
                      adminName: 'Chidinma Okafor',
                      applicationsCount: 142,
                      isActive: true,
                      onEdit: () {},
                    ),
                    const SizedBox(height: 12),
                    _LGAdminCard(
                      name: 'Kano Municipal',
                      state: 'Kano State',
                      adminName: 'Mohammed Yusuf',
                      applicationsCount: 267,
                      isActive: true,
                      onEdit: () {},
                    ),
                    const SizedBox(height: 12),
                    _LGAdminCard(
                      name: 'Port Harcourt',
                      state: 'Rivers State',
                      adminName: null,
                      applicationsCount: null,
                      isActive: false,
                      onEdit: () {},
                    ),
                  ],
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

  const _InviteLGAdminDialog({required this.states});

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
            // TODO: Refresh the list of LG admins
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
