import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/shared/widgets/admin_bottom_nav_bar.dart';

@RoutePage(name: 'AdminApplications')
class AdminApplicationsScreen extends StatefulWidget {
  const AdminApplicationsScreen({super.key});

  @override
  State<AdminApplicationsScreen> createState() =>
      _AdminApplicationsScreenState();
}

class _AdminApplicationsScreenState extends State<AdminApplicationsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = [
    'Pending',
    'Digitization',
    'Approved',
    'Rejected'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                  const Text(
                    'Applications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Tab bar
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final isSelected = _selectedTab == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF9FAFB)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            // Applications list
            Expanded(
              child: Container(
                color: const Color(0xFFF9FAFB),
                child: _buildApplicationsList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildApplicationsList() {
    final List<Widget> applications;

    switch (_selectedTab) {
      case 0: // Pending
        applications = [
          _ApplicationCard(
            name: 'Ada Okafor',
            nin: '12345678901',
            location: 'Ogba Village',
            date: '2025-10-21',
            status: ApplicationStatus.pending,
            onView: () => context.router.pushNamed('/admin/application/detail'),
          ),
          const SizedBox(height: 12),
          _ApplicationCard(
            name: 'Chidi Eze',
            nin: '23456789012',
            location: 'Agege Village',
            date: '2025-10-22',
            status: ApplicationStatus.pending,
            onView: () => context.router.pushNamed('/admin/application/detail'),
          ),
        ];
        break;
      case 1: // Digitization
        applications = [
          _ApplicationCard(
            name: 'Emeka Nwankwo',
            nin: '56789012345',
            location: 'Ikeja Village',
            date: '2025-10-23',
            status: ApplicationStatus.digitized,
            referenceNumber: 'LG/2018/4532',
            paymentStatus: 'Paid',
            onView: () => context.router.pushNamed('/admin/application/detail'),
          ),
          const SizedBox(height: 12),
          _ApplicationCard(
            name: 'Blessing Adeyemi',
            nin: '67890123456',
            location: 'Ikeja Village',
            date: '2025-10-22',
            status: ApplicationStatus.digitized,
            referenceNumber: 'LG/2019/5678',
            paymentStatus: 'Paid',
            onView: () => context.router.pushNamed('/admin/application/detail'),
          ),
        ];
        break;
      case 2: // Approved
        applications = [
          _ApplicationCard(
            name: 'John Doe',
            nin: '34567890123',
            location: 'Ikeja Village',
            date: '2025-10-15',
            status: ApplicationStatus.approved,
            onView: () => context.router.pushNamed('/admin/application/detail'),
          ),
        ];
        break;
      case 3: // Rejected
        applications = [
          _ApplicationCard(
            name: 'Jane Smith',
            nin: '45678901234',
            location: 'Allen Village',
            date: '2025-09-28',
            status: ApplicationStatus.rejected,
            onView: () => context.router.pushNamed('/admin/application/detail'),
          ),
        ];
        break;
      default:
        applications = [];
    }

    if (applications.isEmpty) {
      return Center(
        child: Text(
          'No applications found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: applications,
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final String name;
  final String nin;
  final String location;
  final String date;
  final ApplicationStatus status;
  final String? referenceNumber;
  final String? paymentStatus;
  final VoidCallback onView;

  const _ApplicationCard({
    required this.name,
    required this.nin,
    required this.location,
    required this.date,
    required this.status,
    this.referenceNumber,
    this.paymentStatus,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    if (status == ApplicationStatus.digitized) {
      return _buildDigitizedCard();
    }
    return _buildStandardCard();
  }

  Widget _buildDigitizedCard() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIN: $nin',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.description,
                      size: 16,
                      color: status.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description,
                  size: 20,
                  color: status.color,
                ),
                const SizedBox(width: 8),
                Text(
                  'Uploaded Certificate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: status.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'Certificate Preview',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Payment: ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          paymentStatus ?? 'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: paymentStatus == 'Paid'
                                ? const Color(0xFF10B981)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    if (referenceNumber != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Ref: $referenceNumber',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onView,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Review',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStandardCard() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIN: $nin',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: status.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status.icon,
                      size: 16,
                      color: status.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
