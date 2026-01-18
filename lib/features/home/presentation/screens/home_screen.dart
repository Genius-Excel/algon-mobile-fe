import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/shared/widgets/bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';
import 'package:algon_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:algon_mobile/features/auth/data/models/user_profile_models.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/features/application/data/models/application_list_models.dart';
import '../widgets/apply_card.dart';
import '../widgets/digitize_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_application_card.dart';

@RoutePage(name: 'Home')
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<ApplicationItem> _recentApplications = [];
  bool _isLoadingApplications = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentApplications();
  }

  Future<void> _fetchRecentApplications() async {
    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final result = await applicationRepo.getMyApplications(
        limit: 2,
        offset: 0,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              // Sort by date (latest first) and take only 2
              final sortedList = List<ApplicationItem>.from(
                response.data.results,
              )..sort((a, b) {
                  try {
                    final dateA = DateTime.parse(a.createdAt);
                    final dateB = DateTime.parse(b.createdAt);
                    return dateB.compareTo(dateA);
                  } catch (e) {
                    return 0;
                  }
                });
              _recentApplications = sortedList.take(2).toList();
              _isLoadingApplications = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingApplications = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingApplications = false;
        });
      }
    }
  }

  String _getUserName(UserProfile profile) {
    if (profile.firstName.isNotEmpty) {
      return profile.firstName;
    }
    if (profile.lastName.isNotEmpty) {
      return profile.lastName;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text(
                    'ALGON',
                    style: AppStyles.textStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Consumer(
                builder: (context, ref, child) {
                  final profileAsync = ref.watch(userProfileProvider);
                  return profileAsync.when(
                    data: (profileResponse) {
                      final userName = profileResponse != null
                          ? _getUserName(profileResponse.data)
                          : '';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName.isNotEmpty
                                ? 'Welcome, $userName'
                                : 'Welcome',
                            style: AppStyles.textStyle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Manage your certificates',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerContainer(
                          width: 150,
                          height: 24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 4),
                        ShimmerContainer(
                          width: 200,
                          height: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    error: (error, stack) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: AppStyles.textStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Manage your certificates',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const ApplyCard(),
                    const ColSpacing(16),
                    const DigitizeCard(),
                    const ColSpacing(24),
                    const QuickActions(),
                    const ColSpacing(24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent Applications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoadingApplications) ...[
                      const ShimmerRecentApplicationCard(),
                      const SizedBox(height: 12),
                      const ShimmerRecentApplicationCard(),
                    ] else if (_recentApplications.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No recent applications',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      )
                    else
                      ..._recentApplications.map((app) {
                        final status = ApplicationStatus.fromString(
                          app.applicationStatus,
                        );
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: app == _recentApplications.last ? 0 : 12,
                          ),
                          child: RecentApplicationCard(
                            name: app.fullName.length > 8
                                ? app.fullName.substring(0, 8).toUpperCase()
                                : app.fullName.toUpperCase(),
                            location:
                                '${app.localGovernment.name}, ${app.state.name}',
                            date: DateFormatter.formatDisplayDate(
                              app.createdAt,
                            ),
                            status: status.label,
                            applicationId: app.id,
                          ),
                        );
                      }),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}
