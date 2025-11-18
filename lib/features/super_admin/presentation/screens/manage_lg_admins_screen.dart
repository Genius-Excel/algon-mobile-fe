import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/super_admin_bottom_nav_bar.dart';

@RoutePage(name: 'ManageLGAdmins')
class ManageLGAdminsScreen extends StatefulWidget {
  const ManageLGAdminsScreen({super.key});

  @override
  State<ManageLGAdminsScreen> createState() => _ManageLGAdminsScreenState();
}

class _ManageLGAdminsScreenState extends State<ManageLGAdminsScreen> {
  final _searchController = TextEditingController();

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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFE8F5E3)
                      : Colors.grey[200],
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

