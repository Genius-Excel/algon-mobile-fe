import 'package:algon_mobile/core/router/router.dart';
import 'package:algon_mobile/features/admin/data/repository/application_list_controller.dart';
import 'package:algon_mobile/features/admin/presentation/widgets/application_card.dart';
import 'package:algon_mobile/features/admin/presentation/widgets/application_tabs.dart';
import 'package:algon_mobile/features/application/data/models/application_list_models.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/admin_bottom_nav_bar.dart';

@RoutePage(name: 'AdminApplications')
class AdminApplicationsScreen extends ConsumerStatefulWidget {
  const AdminApplicationsScreen({super.key});

  @override
  ConsumerState<AdminApplicationsScreen> createState() =>
      _AdminApplicationsScreenState();
}

class _AdminApplicationsScreenState
    extends ConsumerState<AdminApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure pending applications are fetched when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(applicationListControllerProvider);
      if (controller.pendingApplications.isEmpty &&
          !controller.isLoadingPending) {
        controller.fetchPendingApplications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(applicationListControllerProvider);
    final tabState = ref.watch(applicationTabProvider);

    // Watch for tab changes and ensure data is loaded when switching to pending
    ref.listen(applicationTabProvider, (previous, next) {
      if (next.selectedTab == ApplicationTab.pending &&
          controller.pendingApplications.isEmpty &&
          !controller.isLoadingPending) {
        controller.fetchPendingApplications();
      }
    });

    // Also check on initial build if pending tab is selected
    if (tabState.selectedTab == ApplicationTab.pending &&
        controller.pendingApplications.isEmpty &&
        !controller.isLoadingPending) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchPendingApplications();
      });
    }

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
            ApplicationTabs(),
            // Applications list
            Expanded(
              child: Container(
                color: const Color(0xFFF9FAFB),
                child: _buildApplicationsList(
                  context: context,
                  controller: controller,
                  tabState: tabState,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildApplicationsList({
    required BuildContext context,
    required ApplicationListController controller,
    required ApplicationTabState tabState,
  }) {
    switch (tabState.selectedTab) {
      case ApplicationTab.pending:
        return _buildList(
          context: context,
          applications: controller.pendingApplications,
          isLoading: controller.isLoadingPending,
          isLoadingMore: controller.isLoadingMorePending,
          hasMore: controller.nextUrlPending != null,
          scrollController: controller.pendingScrollController,
          emptyText: 'No pending applications',
          onRefresh: () => controller.fetchPendingApplications(refresh: true),
          onTap: (application) {
            // Navigate with only the ID
            context.pushRoute(
              AdminApplicationDetailRoute(id: application.id),
            );
          },
        );
      case ApplicationTab.digitization:
        return _buildList(
          context: context,
          applications: controller.digitizationApplications,
          isLoading: controller.isLoadingDigitization,
          isLoadingMore: controller.isLoadingMoreDigitization,
          hasMore: controller.nextUrlDigitization != null,
          scrollController: controller.digitizationScrollController,
          emptyText: 'No digitization applications',
          onRefresh: () =>
              controller.fetchDigitizationApplications(refresh: true),
          onTap: (application) {
            context.pushRoute(
              AdminApplicationDetailRoute(id: application.id),
            );
          },
        );
      case ApplicationTab.approved:
        return _buildList(
          context: context,
          applications: controller.approvedApplications,
          isLoading: controller.isLoadingApproved,
          isLoadingMore: controller.isLoadingMoreApproved,
          hasMore: controller.nextUrlApproved != null,
          scrollController: controller.approvedScrollController,
          emptyText: 'No approved applications',
          onRefresh: () => controller.fetchApprovedApplications(refresh: true),
          onTap: (application) {
            context.pushRoute(
              AdminApplicationDetailRoute(id: application.id),
            );
          },
        );
      case ApplicationTab.rejected:
        return _buildList(
          context: context,
          applications: controller.rejectedApplications,
          isLoading: controller.isLoadingRejected,
          isLoadingMore: controller.isLoadingMoreRejected,
          hasMore: controller.nextUrlRejected != null,
          scrollController: controller.rejectedScrollController,
          emptyText: 'No rejected applications',
          onRefresh: () => controller.fetchRejectedApplications(refresh: true),
          onTap: (application) {
            context.pushRoute(
              AdminApplicationDetailRoute(id: application.id),
            );
          },
        );
      default:
        return const Center(child: Text('Unknown tab'));
    }
  }

  Widget _buildList({
    required BuildContext context,
    required List<ApplicationItem> applications,
    required bool isLoading,
    required bool isLoadingMore,
    required bool hasMore,
    required ScrollController scrollController,
    required String emptyText,
    required Future<void> Function() onRefresh,
    required Function(ApplicationItem) onTap,
  }) {
    if (isLoading && applications.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < 4 ? 12 : 0),
            child: const ShimmerApplicationCard(),
          );
        },
      );
    }

    if (applications.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: applications.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= applications.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: isLoadingMore
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
              ),
            );
          }
          final application = applications[index];
          return Padding(
            padding: EdgeInsets.only(
                bottom: index < applications.length - 1 ? 12 : 0),
            child: ApplicationCard(
              application: application,
              onTap: () => onTap(application),
            ),
          );
        },
      ),
    );
  }
}
