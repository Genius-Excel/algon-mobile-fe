import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/admin/data/repository/admin_repository.dart';
import 'package:algon_mobile/features/application/data/models/application_list_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

final applicationListControllerProvider =
    Provider<ApplicationListController>((ref) {
  return ApplicationListController(ref);
});

class ApplicationListController {
  final Ref _ref;
  final int _pageSize = 20;

  // Pending applications
  bool isLoadingPending = true;
  bool isLoadingMorePending = false;
  List<ApplicationItem> pendingApplications = [];
  String? nextUrlPending;
  final ScrollController pendingScrollController = ScrollController();

  // Approved applications
  bool isLoadingApproved = true;
  bool isLoadingMoreApproved = false;
  List<ApplicationItem> approvedApplications = [];
  String? nextUrlApproved;
  final ScrollController approvedScrollController = ScrollController();

  // Rejected applications
  bool isLoadingRejected = true;
  bool isLoadingMoreRejected = false;
  List<ApplicationItem> rejectedApplications = [];
  String? nextUrlRejected;
  final ScrollController rejectedScrollController = ScrollController();

  // Digitization applications
  bool isLoadingDigitization = true;
  bool isLoadingMoreDigitization = false;
  List<ApplicationItem> digitizationApplications = [];
  String? nextUrlDigitization;
  final ScrollController digitizationScrollController = ScrollController();

  ApplicationListController(this._ref) {
    _setupScrollListeners();
    _initialize();
  }

  void _setupScrollListeners() {
    pendingScrollController.addListener(_onPendingScroll);
    approvedScrollController.addListener(_onApprovedScroll);
    rejectedScrollController.addListener(_onRejectedScroll);
    digitizationScrollController.addListener(_onDigitizationScroll);
  }

  void _initialize() {
    fetchPendingApplications();
    fetchApprovedApplications();
    fetchRejectedApplications();
    fetchDigitizationApplications();
  }

  void _onPendingScroll() {
    if (pendingScrollController.position.pixels >=
            pendingScrollController.position.maxScrollExtent * 0.8 &&
        nextUrlPending != null &&
        !isLoadingMorePending) {
      _loadMorePendingApplications();
    }
  }

  void _onApprovedScroll() {
    if (approvedScrollController.position.pixels >=
            approvedScrollController.position.maxScrollExtent * 0.8 &&
        nextUrlApproved != null &&
        !isLoadingMoreApproved) {
      _loadMoreApprovedApplications();
    }
  }

  void _onRejectedScroll() {
    if (rejectedScrollController.position.pixels >=
            rejectedScrollController.position.maxScrollExtent * 0.8 &&
        nextUrlRejected != null &&
        !isLoadingMoreRejected) {
      _loadMoreRejectedApplications();
    }
  }

  void _onDigitizationScroll() {
    if (digitizationScrollController.position.pixels >=
            digitizationScrollController.position.maxScrollExtent * 0.8 &&
        nextUrlDigitization != null &&
        !isLoadingMoreDigitization) {
      _loadMoreDigitizationApplications();
    }
  }

  Future<void> fetchPendingApplications({bool refresh = false}) async {
    if (refresh) {
      nextUrlPending = null;
      pendingApplications.clear();
    }

    isLoadingPending = true;

    try {
      final adminRepo = _ref.read(adminRepositoryProvider);
      final result = await adminRepo.getApplications(
        applicationType: 'certificate',
        limit: _pageSize,
        offset: refresh || pendingApplications.isEmpty
            ? 0
            : pendingApplications.length,
      );

      result.when(
        success: (ApplicationListResponse response) {
          if (refresh) {
            pendingApplications = response.data.results
                .where((app) => app.applicationStatus.toLowerCase() == 'pending')
                .toList();
          } else {
            pendingApplications.addAll(response.data.results
                .where((app) => app.applicationStatus.toLowerCase() == 'pending'));
          }
          _sortApplications(pendingApplications);
          nextUrlPending = response.data.next;
          isLoadingPending = false;
        },
        apiFailure: (error, statusCode) {
          isLoadingPending = false;
          _showError(error, 'Failed to load pending applications');
        },
      );
    } catch (e) {
      isLoadingPending = false;
      _showError(e, 'Failed to load pending applications');
    }
  }

  Future<void> _loadMorePendingApplications() async {
    if (nextUrlPending == null || isLoadingMorePending) return;

    isLoadingMorePending = true;

    try {
      final adminRepo = _ref.read(adminRepositoryProvider);
      final result = await adminRepo.getApplications(
        applicationType: 'certificate',
        limit: _pageSize,
        offset: pendingApplications.length,
      );

      result.when(
        success: (ApplicationListResponse response) {
          pendingApplications.addAll(response.data.results
              .where((app) => app.applicationStatus.toLowerCase() == 'pending'));
          _sortApplications(pendingApplications);
          nextUrlPending = response.data.next;
          isLoadingMorePending = false;
        },
        apiFailure: (error, statusCode) {
          isLoadingMorePending = false;
        },
      );
    } catch (e) {
      isLoadingMorePending = false;
    }
  }

  Future<void> fetchApprovedApplications({bool refresh = false}) async {
    if (refresh) {
      nextUrlApproved = null;
      approvedApplications.clear();
    }

    isLoadingApproved = true;

    try {
      final adminRepo = _ref.read(adminRepositoryProvider);
      final result = await adminRepo.getApplications(
        applicationType: 'certificate',
        limit: _pageSize,
        offset: refresh || approvedApplications.isEmpty
            ? 0
            : approvedApplications.length,
      );

      result.when(
        success: (ApplicationListResponse response) {
          if (refresh) {
            approvedApplications = response.data.results
                .where((app) => app.applicationStatus.toLowerCase() == 'approved')
                .toList();
          } else {
            approvedApplications.addAll(response.data.results
                .where((app) => app.applicationStatus.toLowerCase() == 'approved'));
          }
          _sortApplications(approvedApplications);
          nextUrlApproved = response.data.next;
          isLoadingApproved = false;
        },
        apiFailure: (error, statusCode) {
          isLoadingApproved = false;
        },
      );
    } catch (e) {
      isLoadingApproved = false;
    }
  }

  Future<void> _loadMoreApprovedApplications() async {
    if (nextUrlApproved == null || isLoadingMoreApproved) return;

    isLoadingMoreApproved = true;

    try {
      final adminRepo = _ref.read(adminRepositoryProvider);
      final result = await adminRepo.getApplications(
        applicationType: 'certificate',
        limit: _pageSize,
        offset: approvedApplications.length,
      );

      result.when(
        success: (ApplicationListResponse response) {
          approvedApplications.addAll(response.data.results
              .where((app) => app.applicationStatus.toLowerCase() == 'approved'));
          _sortApplications(approvedApplications);
          nextUrlApproved = response.data.next;
          isLoadingMoreApproved = false;
        },
        apiFailure: (error, statusCode) {
          isLoadingMoreApproved = false;
        },
      );
    } catch (e) {
      isLoadingMoreApproved = false;
    }
  }

  Future<void> fetchRejectedApplications({bool refresh = false}) async {
    if (refresh) {
      nextUrlRejected = null;
      rejectedApplications.clear();
    }

    isLoadingRejected = true;

    try {
      final adminRepo = _ref.read(adminRepositoryProvider);
      final result = await adminRepo.getApplications(
        applicationType: 'certificate',
        limit: _pageSize,
        offset: refresh || rejectedApplications.isEmpty
            ? 0
            : rejectedApplications.length,
      );

      result.when(
        success: (ApplicationListResponse response) {
          if (refresh) {
            rejectedApplications = response.data.results
                .where((app) => app.applicationStatus.toLowerCase() == 'rejected')
                .toList();
          } else {
            rejectedApplications.addAll(response.data.results
                .where((app) => app.applicationStatus.toLowerCase() == 'rejected'));
          }
          _sortApplications(rejectedApplications);
          nextUrlRejected = response.data.next;
          isLoadingRejected = false;
        },
        apiFailure: (error, statusCode) {
          isLoadingRejected = false;
        },
      );
    } catch (e) {
      isLoadingRejected = false;
    }
  }

  Future<void> _loadMoreRejectedApplications() async {
    if (nextUrlRejected == null || isLoadingMoreRejected) return;

    isLoadingMoreRejected = true;

    try {
      final adminRepo = _ref.read(adminRepositoryProvider);
      final result = await adminRepo.getApplications(
        applicationType: 'certificate',
        limit: _pageSize,
        offset: rejectedApplications.length,
      );

      result.when(
        success: (ApplicationListResponse response) {
          rejectedApplications.addAll(response.data.results
              .where((app) => app.applicationStatus.toLowerCase() == 'rejected'));
          _sortApplications(rejectedApplications);
          nextUrlRejected = response.data.next;
          isLoadingMoreRejected = false;
        },
        apiFailure: (error, statusCode) {
          isLoadingMoreRejected = false;
        },
      );
    } catch (e) {
      isLoadingMoreRejected = false;
    }
  }

  Future<void> fetchDigitizationApplications({bool refresh = false}) async {
    if (refresh) {
      nextUrlDigitization = null;
      digitizationApplications.clear();
    }

    isLoadingDigitization = true;

    try {
      final adminRepo = _ref.read(adminRepositoryProvider);
      final result = await adminRepo.getApplications(
        applicationType: 'digitization',
        limit: _pageSize,
        offset: refresh || digitizationApplications.isEmpty
            ? 0
            : digitizationApplications.length,
      );

      result.when(
        success: (ApplicationListResponse response) {
          if (refresh) {
            digitizationApplications = response.data.results;
          } else {
            digitizationApplications.addAll(response.data.results);
          }
          _sortApplications(digitizationApplications);
          nextUrlDigitization = response.data.next;
          isLoadingDigitization = false;
        },
        apiFailure: (error, statusCode) {
          isLoadingDigitization = false;
          _showError(error, 'Failed to load digitization applications');
        },
      );
    } catch (e) {
      isLoadingDigitization = false;
      _showError(e, 'Failed to load digitization applications');
    }
  }

  Future<void> _loadMoreDigitizationApplications() async {
    if (nextUrlDigitization == null || isLoadingMoreDigitization) return;

    isLoadingMoreDigitization = true;

    try {
      final adminRepo = _ref.read(adminRepositoryProvider);
      final result = await adminRepo.getApplications(
        applicationType: 'digitization',
        limit: _pageSize,
        offset: digitizationApplications.length,
      );

      result.when(
        success: (ApplicationListResponse response) {
          digitizationApplications.addAll(response.data.results);
          _sortApplications(digitizationApplications);
          nextUrlDigitization = response.data.next;
          isLoadingMoreDigitization = false;
        },
        apiFailure: (error, statusCode) {
          isLoadingMoreDigitization = false;
        },
      );
    } catch (e) {
      isLoadingMoreDigitization = false;
    }
  }

  void _sortApplications(List<ApplicationItem> applications) {
    applications.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });
  }

  void _showError(dynamic error, String defaultMessage) {
    // You could use a state provider to show errors in the UI
    if (error is ApiExceptions) {
      // Handle API error
    } else {
      // Handle other errors
    }
  }

  void dispose() {
    pendingScrollController.dispose();
    approvedScrollController.dispose();
    rejectedScrollController.dispose();
    digitizationScrollController.dispose();
  }
}