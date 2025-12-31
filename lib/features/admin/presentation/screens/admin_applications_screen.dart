// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:algon_mobile/src/constants/app_colors.dart';
// import 'package:algon_mobile/core/enums/application_status.dart';
// import 'package:algon_mobile/core/enums/payment_status.dart';
// import 'package:algon_mobile/shared/widgets/admin_bottom_nav_bar.dart';
// import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
// import 'package:algon_mobile/shared/widgets/toast.dart';
// import 'package:algon_mobile/shared/widgets/custom_button.dart';
// import 'package:algon_mobile/features/admin/data/repository/admin_repository.dart';
// import 'package:algon_mobile/features/application/data/models/application_list_models.dart';
// import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
// import 'package:algon_mobile/core/utils/date_formatter.dart';

// @RoutePage(name: 'AdminApplications')
// class AdminApplicationsScreen extends ConsumerStatefulWidget {
//   const AdminApplicationsScreen({super.key});

//   @override
//   ConsumerState<AdminApplicationsScreen> createState() =>
//       _AdminApplicationsScreenState();
// }

// class _AdminApplicationsScreenState
//     extends ConsumerState<AdminApplicationsScreen> {
//   int _selectedTab = 0;
//   final List<String> _tabs = [
//     'Pending',
//     'Digitization',
//     'Approved',
//     'Rejected'
//   ];

//   // Pending applications
//   bool _isLoadingPending = true;
//   bool _isLoadingMorePending = false;
//   List<ApplicationItem> _pendingApplications = [];
//   String? _nextUrlPending;
//   final ScrollController _pendingScrollController = ScrollController();
//   static const int _pageSize = 20;

//   // Approved applications
//   bool _isLoadingApproved = true;
//   bool _isLoadingMoreApproved = false;
//   List<ApplicationItem> _approvedApplications = [];
//   String? _nextUrlApproved;
//   final ScrollController _approvedScrollController = ScrollController();

//   // Rejected applications
//   bool _isLoadingRejected = true;
//   bool _isLoadingMoreRejected = false;
//   List<ApplicationItem> _rejectedApplications = [];
//   String? _nextUrlRejected;
//   final ScrollController _rejectedScrollController = ScrollController();

//   // Digitization applications
//   bool _isLoadingDigitization = true;
//   bool _isLoadingMoreDigitization = false;
//   List<ApplicationItem> _digitizationApplications = [];
//   String? _nextUrlDigitization;
//   final ScrollController _digitizationScrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _pendingScrollController.addListener(() => _onPendingScroll());
//     _approvedScrollController.addListener(() => _onApprovedScroll());
//     _rejectedScrollController.addListener(() => _onRejectedScroll());
//     _digitizationScrollController.addListener(() => _onDigitizationScroll());
//     _fetchPendingApplications();
//     _fetchApprovedApplications();
//     _fetchRejectedApplications();
//     _fetchDigitizationApplications();
//   }

//   @override
//   void dispose() {
//     _pendingScrollController.dispose();
//     _approvedScrollController.dispose();
//     _rejectedScrollController.dispose();
//     _digitizationScrollController.dispose();
//     super.dispose();
//   }

//   void _onPendingScroll() {
//     if (_pendingScrollController.position.pixels >=
//             _pendingScrollController.position.maxScrollExtent * 0.8 &&
//         _nextUrlPending != null &&
//         !_isLoadingMorePending) {
//       _loadMorePendingApplications();
//     }
//   }

//   void _onApprovedScroll() {
//     if (_approvedScrollController.position.pixels >=
//             _approvedScrollController.position.maxScrollExtent * 0.8 &&
//         _nextUrlApproved != null &&
//         !_isLoadingMoreApproved) {
//       _loadMoreApprovedApplications();
//     }
//   }

//   void _onRejectedScroll() {
//     if (_rejectedScrollController.position.pixels >=
//             _rejectedScrollController.position.maxScrollExtent * 0.8 &&
//         _nextUrlRejected != null &&
//         !_isLoadingMoreRejected) {
//       _loadMoreRejectedApplications();
//     }
//   }

//   void _onDigitizationScroll() {
//     if (_digitizationScrollController.position.pixels >=
//             _digitizationScrollController.position.maxScrollExtent * 0.8 &&
//         _nextUrlDigitization != null &&
//         !_isLoadingMoreDigitization) {
//       _loadMoreDigitizationApplications();
//     }
//   }

//   Future<void> _fetchPendingApplications({bool refresh = false}) async {
//     if (refresh) {
//       _nextUrlPending = null;
//       _pendingApplications.clear();
//     }

//     setState(() {
//       _isLoadingPending = true;
//     });

//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.getApplications(
//         applicationType: 'certificate',
//         limit: _pageSize,
//         offset: refresh || _pendingApplications.isEmpty
//             ? 0
//             : _pendingApplications.length,
//       );

//       result.when(
//         success: (ApplicationListResponse response) {
//           if (mounted) {
//             setState(() {
//               if (refresh) {
//                 _pendingApplications = response.data.results
//                     .where((app) =>
//                         app.applicationStatus.toLowerCase() == 'pending')
//                     .toList();
//               } else {
//                 _pendingApplications.addAll(response.data.results.where(
//                     (app) => app.applicationStatus.toLowerCase() == 'pending'));
//               }
//               // Sort by date (latest first)
//               _pendingApplications.sort((a, b) {
//                 try {
//                   final dateA = DateTime.parse(a.createdAt);
//                   final dateB = DateTime.parse(b.createdAt);
//                   return dateB.compareTo(dateA);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//               _nextUrlPending = response.data.next;
//               _isLoadingPending = false;
//             });
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             setState(() {
//               _isLoadingPending = false;
//             });
//             if (error is ApiExceptions) {
//               Toast.apiError(error, context);
//             } else {
//               Toast.error(error.toString(), context);
//             }
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingPending = false;
//         });
//         Toast.error('Failed to load applications: ${e.toString()}', context);
//       }
//     }
//   }

//   Future<void> _loadMorePendingApplications() async {
//     if (_nextUrlPending == null || _isLoadingMorePending) return;

//     setState(() {
//       _isLoadingMorePending = true;
//     });

//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.getApplications(
//         applicationType: 'certificate',
//         limit: _pageSize,
//         offset: _pendingApplications.length,
//       );

//       result.when(
//         success: (ApplicationListResponse response) {
//           if (mounted) {
//             setState(() {
//               _pendingApplications.addAll(response.data.results.where(
//                   (app) => app.applicationStatus.toLowerCase() == 'pending'));
//               // Sort by date (latest first)
//               _pendingApplications.sort((a, b) {
//                 try {
//                   final dateA = DateTime.parse(a.createdAt);
//                   final dateB = DateTime.parse(b.createdAt);
//                   return dateB.compareTo(dateA);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//               _nextUrlPending = response.data.next;
//               _isLoadingMorePending = false;
//             });
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             setState(() {
//               _isLoadingMorePending = false;
//             });
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingMorePending = false;
//         });
//       }
//     }
//   }

//   Future<void> _fetchApprovedApplications({bool refresh = false}) async {
//     if (refresh) {
//       _nextUrlApproved = null;
//       _approvedApplications.clear();
//     }

//     setState(() {
//       _isLoadingApproved = true;
//     });

//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.getApplications(
//         applicationType: 'certificate',
//         limit: _pageSize,
//         offset: refresh || _approvedApplications.isEmpty
//             ? 0
//             : _approvedApplications.length,
//       );

//       result.when(
//         success: (ApplicationListResponse response) {
//           if (mounted) {
//             setState(() {
//               if (refresh) {
//                 _approvedApplications = response.data.results
//                     .where((app) =>
//                         app.applicationStatus.toLowerCase() == 'approved')
//                     .toList();
//               } else {
//                 _approvedApplications.addAll(response.data.results.where(
//                     (app) =>
//                         app.applicationStatus.toLowerCase() == 'approved'));
//               }
//               // Sort by date (latest first)
//               _approvedApplications.sort((a, b) {
//                 try {
//                   final dateA = DateTime.parse(a.createdAt);
//                   final dateB = DateTime.parse(b.createdAt);
//                   return dateB.compareTo(dateA);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//               _nextUrlApproved = response.data.next;
//               _isLoadingApproved = false;
//             });
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             setState(() {
//               _isLoadingApproved = false;
//             });
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingApproved = false;
//         });
//       }
//     }
//   }

//   Future<void> _loadMoreApprovedApplications() async {
//     if (_nextUrlApproved == null || _isLoadingMoreApproved) return;

//     setState(() {
//       _isLoadingMoreApproved = true;
//     });

//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.getApplications(
//         applicationType: 'certificate',
//         limit: _pageSize,
//         offset: _approvedApplications.length,
//       );

//       result.when(
//         success: (ApplicationListResponse response) {
//           if (mounted) {
//             setState(() {
//               _approvedApplications.addAll(response.data.results.where(
//                   (app) => app.applicationStatus.toLowerCase() == 'approved'));
//               // Sort by date (latest first)
//               _approvedApplications.sort((a, b) {
//                 try {
//                   final dateA = DateTime.parse(a.createdAt);
//                   final dateB = DateTime.parse(b.createdAt);
//                   return dateB.compareTo(dateA);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//               _nextUrlApproved = response.data.next;
//               _isLoadingMoreApproved = false;
//             });
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             setState(() {
//               _isLoadingMoreApproved = false;
//             });
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingMoreApproved = false;
//         });
//       }
//     }
//   }

//   Future<void> _fetchRejectedApplications({bool refresh = false}) async {
//     if (refresh) {
//       _nextUrlRejected = null;
//       _rejectedApplications.clear();
//     }

//     setState(() {
//       _isLoadingRejected = true;
//     });

//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.getApplications(
//         applicationType: 'certificate',
//         limit: _pageSize,
//         offset: refresh || _rejectedApplications.isEmpty
//             ? 0
//             : _rejectedApplications.length,
//       );

//       result.when(
//         success: (ApplicationListResponse response) {
//           if (mounted) {
//             setState(() {
//               if (refresh) {
//                 _rejectedApplications = response.data.results
//                     .where((app) =>
//                         app.applicationStatus.toLowerCase() == 'rejected')
//                     .toList();
//               } else {
//                 _rejectedApplications.addAll(response.data.results.where(
//                     (app) =>
//                         app.applicationStatus.toLowerCase() == 'rejected'));
//               }
//               // Sort by date (latest first)
//               _rejectedApplications.sort((a, b) {
//                 try {
//                   final dateA = DateTime.parse(a.createdAt);
//                   final dateB = DateTime.parse(b.createdAt);
//                   return dateB.compareTo(dateA);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//               _nextUrlRejected = response.data.next;
//               _isLoadingRejected = false;
//             });
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             setState(() {
//               _isLoadingRejected = false;
//             });
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingRejected = false;
//         });
//       }
//     }
//   }

//   Future<void> _loadMoreRejectedApplications() async {
//     if (_nextUrlRejected == null || _isLoadingMoreRejected) return;

//     setState(() {
//       _isLoadingMoreRejected = true;
//     });

//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.getApplications(
//         applicationType: 'certificate',
//         limit: _pageSize,
//         offset: _rejectedApplications.length,
//       );

//       result.when(
//         success: (ApplicationListResponse response) {
//           if (mounted) {
//             setState(() {
//               _rejectedApplications.addAll(response.data.results.where(
//                   (app) => app.applicationStatus.toLowerCase() == 'rejected'));
//               // Sort by date (latest first)
//               _rejectedApplications.sort((a, b) {
//                 try {
//                   final dateA = DateTime.parse(a.createdAt);
//                   final dateB = DateTime.parse(b.createdAt);
//                   return dateB.compareTo(dateA);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//               _nextUrlRejected = response.data.next;
//               _isLoadingMoreRejected = false;
//             });
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             setState(() {
//               _isLoadingMoreRejected = false;
//             });
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingMoreRejected = false;
//         });
//       }
//     }
//   }

//   Future<void> _fetchDigitizationApplications({bool refresh = false}) async {
//     if (refresh) {
//       _nextUrlDigitization = null;
//       _digitizationApplications.clear();
//     }

//     setState(() {
//       _isLoadingDigitization = true;
//     });

//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.getApplications(
//         applicationType: 'digitization',
//         limit: _pageSize,
//         offset: refresh || _digitizationApplications.isEmpty
//             ? 0
//             : _digitizationApplications.length,
//       );

//       result.when(
//         success: (ApplicationListResponse response) {
//           if (mounted) {
//             setState(() {
//               if (refresh) {
//                 _digitizationApplications = response.data.results;
//               } else {
//                 _digitizationApplications.addAll(response.data.results);
//               }
//               // Sort by date (latest first)
//               _digitizationApplications.sort((a, b) {
//                 try {
//                   final dateA = DateTime.parse(a.createdAt);
//                   final dateB = DateTime.parse(b.createdAt);
//                   return dateB.compareTo(dateA);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//               _nextUrlDigitization = response.data.next;
//               _isLoadingDigitization = false;
//             });
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             setState(() {
//               _isLoadingDigitization = false;
//             });
//             if (error is ApiExceptions) {
//               Toast.apiError(error, context);
//             } else {
//               Toast.error(error.toString(), context);
//             }
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingDigitization = false;
//         });
//         Toast.error('Failed to load digitization applications: ${e.toString()}',
//             context);
//       }
//     }
//   }

//   Future<void> _loadMoreDigitizationApplications() async {
//     if (_nextUrlDigitization == null || _isLoadingMoreDigitization) return;

//     setState(() {
//       _isLoadingMoreDigitization = true;
//     });

//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.getApplications(
//         applicationType: 'digitization',
//         limit: _pageSize,
//         offset: _digitizationApplications.length,
//       );

//       result.when(
//         success: (ApplicationListResponse response) {
//           if (mounted) {
//             setState(() {
//               _digitizationApplications.addAll(response.data.results);
//               // Sort by date (latest first)
//               _digitizationApplications.sort((a, b) {
//                 try {
//                   final dateA = DateTime.parse(a.createdAt);
//                   final dateB = DateTime.parse(b.createdAt);
//                   return dateB.compareTo(dateA);
//                 } catch (e) {
//                   return 0;
//                 }
//               });
//               _nextUrlDigitization = response.data.next;
//               _isLoadingMoreDigitization = false;
//             });
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             setState(() {
//               _isLoadingMoreDigitization = false;
//             });
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingMoreDigitization = false;
//         });
//       }
//     }
//   }

//   Future<void> _updateApplicationStatus({
//     required String applicationId,
//     required String action,
//   }) async {
//     try {
//       final adminRepo = ref.read(adminRepositoryProvider);
//       final result = await adminRepo.updateApplicationStatus(
//         applicationId: applicationId,
//         applicationType: 'certificate',
//         action: action,
//       );

//       result.when(
//         success: (response) {
//           if (mounted) {
//             Toast.success(response.message, context);
//             // Refresh all tabs
//             _fetchPendingApplications(refresh: true);
//             _fetchApprovedApplications(refresh: true);
//             _fetchRejectedApplications(refresh: true);
//           }
//         },
//         apiFailure: (error, statusCode) {
//           if (mounted) {
//             if (error is ApiExceptions) {
//               Toast.apiError(error, context);
//             } else {
//               Toast.error(error.toString(), context);
//             }
//           }
//         },
//       );
//     } catch (e) {
//       if (mounted) {
//         Toast.error('Failed to update application: ${e.toString()}', context);
//       }
//     }
//   }

//   void _showApproveRejectDialog(ApplicationItem application) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: 'Close',
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return const SizedBox.shrink();
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return ScaleTransition(
//           scale: CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeOut,
//           ),
//           child: Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Application Action',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1F2937),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'What would you like to do with this application?',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(
//                           text: 'Reject',
//                           variant: ButtonVariant.outline,
//                           backgroundColor: Colors.white,
//                           textColor: Colors.red,
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             _updateApplicationStatus(
//                               applicationId: application.id,
//                               action: 'rejected',
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: CustomButton(
//                           text: 'Approve',
//                           variant: ButtonVariant.primary,
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             _updateApplicationStatus(
//                               applicationId: application.id,
//                               action: 'approved',
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Container(
//               decoration: const BoxDecoration(
//                 gradient: AppColors.primaryGradient,
//               ),
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => context.router.maybePop(),
//                   ),
//                   const Text(
//                     'Applications',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Tab bar
//             Container(
//               color: Colors.white,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: List.generate(_tabs.length, (index) {
//                     final isSelected = _selectedTab == index;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _selectedTab = index;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? const Color(0xFFF9FAFB)
//                               : Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           _tabs[index],
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: isSelected
//                                 ? FontWeight.w600
//                                 : FontWeight.normal,
//                             color: const Color(0xFF1F2937),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//             // Applications list
//             Expanded(
//               child: Container(
//                 color: const Color(0xFFF9FAFB),
//                 child: _buildApplicationsList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
//     );
//   }

//   Widget _buildApplicationsList() {
//     switch (_selectedTab) {
//       case 0: // Pending
//         return _buildPendingList();
//       case 1: // Digitization
//         return _buildDigitizationList();
//       case 2: // Approved
//         return _buildApprovedList();
//       case 3: // Rejected
//         return _buildRejectedList();
//       default:
//         return const Center(child: Text('Unknown tab'));
//     }
//   }

//   Widget _buildPendingList() {
//     if (_isLoadingPending && _pendingApplications.isEmpty) {
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.only(bottom: index < 4 ? 12 : 0),
//             child: const ShimmerApplicationCard(),
//           );
//         },
//       );
//     }

//     if (_pendingApplications.isEmpty) {
//       return Center(
//         child: Text(
//           'No pending applications',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: () => _fetchPendingApplications(refresh: true),
//       child: ListView.builder(
//         controller: _pendingScrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount:
//             _pendingApplications.length + (_nextUrlPending != null ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index >= _pendingApplications.length) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: _isLoadingMorePending
//                     ? const CircularProgressIndicator()
//                     : const SizedBox.shrink(),
//               ),
//             );
//           }
//           final application = _pendingApplications[index];
//           return Padding(
//             padding: EdgeInsets.only(
//                 bottom: index < _pendingApplications.length - 1 ? 12 : 0),
//             child: _ApplicationCard(
//               application: application,
//               onTap: () => _showApproveRejectDialog(application),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildApprovedList() {
//     if (_isLoadingApproved && _approvedApplications.isEmpty) {
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.only(bottom: index < 4 ? 12 : 0),
//             child: const ShimmerApplicationCard(),
//           );
//         },
//       );
//     }

//     if (_approvedApplications.isEmpty) {
//       return Center(
//         child: Text(
//           'No approved applications',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: () => _fetchApprovedApplications(refresh: true),
//       child: ListView.builder(
//         controller: _approvedScrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount:
//             _approvedApplications.length + (_nextUrlApproved != null ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index >= _approvedApplications.length) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: _isLoadingMoreApproved
//                     ? const CircularProgressIndicator()
//                     : const SizedBox.shrink(),
//               ),
//             );
//           }
//           final application = _approvedApplications[index];
//           return Padding(
//             padding: EdgeInsets.only(
//                 bottom: index < _approvedApplications.length - 1 ? 12 : 0),
//             child: _ApplicationCard(
//               application: application,
//               onTap: () {},
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildRejectedList() {
//     if (_isLoadingRejected && _rejectedApplications.isEmpty) {
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.only(bottom: index < 4 ? 12 : 0),
//             child: const ShimmerApplicationCard(),
//           );
//         },
//       );
//     }

//     if (_rejectedApplications.isEmpty) {
//       return Center(
//         child: Text(
//           'No rejected applications',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: () => _fetchRejectedApplications(refresh: true),
//       child: ListView.builder(
//         controller: _rejectedScrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount:
//             _rejectedApplications.length + (_nextUrlRejected != null ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index >= _rejectedApplications.length) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: _isLoadingMoreRejected
//                     ? const CircularProgressIndicator()
//                     : const SizedBox.shrink(),
//               ),
//             );
//           }
//           final application = _rejectedApplications[index];
//           return Padding(
//             padding: EdgeInsets.only(
//                 bottom: index < _rejectedApplications.length - 1 ? 12 : 0),
//             child: _ApplicationCard(
//               application: application,
//               onTap: () {},
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDigitizationList() {
//     if (_isLoadingDigitization && _digitizationApplications.isEmpty) {
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.only(bottom: index < 4 ? 12 : 0),
//             child: const ShimmerApplicationCard(),
//           );
//         },
//       );
//     }

//     if (_digitizationApplications.isEmpty) {
//       return Center(
//         child: Text(
//           'No digitization applications',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: () => _fetchDigitizationApplications(refresh: true),
//       child: ListView.builder(
//         controller: _digitizationScrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount: _digitizationApplications.length +
//             (_nextUrlDigitization != null ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index >= _digitizationApplications.length) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: _isLoadingMoreDigitization
//                     ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator.adaptive(),
//                       )
//                     : const SizedBox(width: 24, height: 24),
//               ),
//             );
//           }
//           final application = _digitizationApplications[index];
//           return Padding(
//             padding: EdgeInsets.only(
//                 bottom: index < _digitizationApplications.length - 1 ? 12 : 0),
//             child: _ApplicationCard(
//               application: application,
//               onTap: () {},
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _ApplicationCard extends StatelessWidget {
//   final ApplicationItem application;
//   final VoidCallback onTap;

//   const _ApplicationCard({
//     required this.application,
//     required this.onTap,
//   });

//   ApplicationStatus get _status {
//     return ApplicationStatus.fromString(application.applicationStatus);
//   }

//   PaymentStatus get _paymentStatus {
//     return PaymentStatus.fromString(application.paymentStatus);
//   }

//   String get _location {
//     return '${application.localGovernment.name}, ${application.state.name}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         application.fullName,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'NIN: ${application.nin}',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         _location,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         DateFormatter.formatDisplayDate(application.createdAt),
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF9CA3AF),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _status.backgroundColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(_status.icon, size: 16, color: _status.color),
//                       const SizedBox(width: 6),
//                       Text(
//                         _status.label,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: _status.color,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             if (_paymentStatus == PaymentStatus.successful) ...[
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _paymentStatus.backgroundColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(_paymentStatus.icon,
//                         size: 12, color: _paymentStatus.color),
//                     const SizedBox(width: 4),
//                     Text(
//                       _paymentStatus.label,
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: _paymentStatus.color,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

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
class AdminApplicationsScreen extends ConsumerWidget {
  const AdminApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(applicationListControllerProvider);
    final tabState = ref.watch(applicationTabProvider);

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
