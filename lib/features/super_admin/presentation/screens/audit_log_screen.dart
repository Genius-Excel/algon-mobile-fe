import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:algon_mobile/shared/widgets/super_admin_bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';
import 'package:algon_mobile/features/super_admin/data/repository/super_admin_repository.dart';
import 'package:algon_mobile/features/super_admin/data/models/audit_log_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'AuditLog')
class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  List<AuditLogItem> _auditLogs = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _nextUrl;
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _fetchAuditLogs();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        _nextUrl != null &&
        !_isLoadingMore) {
      _loadMoreAuditLogs();
    }
  }

  Future<void> _fetchAuditLogs({bool refresh = false}) async {
    if (refresh) {
      _nextUrl = null;
      _auditLogs.clear();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final superAdminRepo = ref.read(superAdminRepositoryProvider);
      final result = await superAdminRepo.getAuditLogs(
        page: 1,
        pageSize: _pageSize,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _auditLogs = response.data.results;
              _nextUrl = response.data.next;
              _isLoading = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
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
        setState(() {
          _isLoading = false;
        });
        Toast.error('Failed to load audit logs: ${e.toString()}', context);
      }
    }
  }

  Future<void> _loadMoreAuditLogs() async {
    if (_nextUrl == null || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final superAdminRepo = ref.read(superAdminRepositoryProvider);
      // Calculate page number from current list length
      final currentPage = (_auditLogs.length ~/ _pageSize) + 1;
      final result = await superAdminRepo.getAuditLogs(
        page: currentPage,
        pageSize: _pageSize,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _auditLogs.addAll(response.data.results);
              _nextUrl = response.data.next;
              _isLoadingMore = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
            // Don't show error toast for pagination failures
            print('❌ Failed to load more audit logs: $error');
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        print('❌ Failed to load more audit logs: ${e.toString()}');
      }
    }
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'create':
        return Icons.add_circle;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'view':
        return Icons.visibility;
      case 'approve':
        return Icons.check_circle;
      case 'reject':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color _getActionColor(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'login':
        return const Color(0xFF3B82F6);
      case 'create':
        return AppColors.green;
      case 'update':
        return const Color(0xFFF59E0B);
      case 'delete':
      case 'reject':
        return const Color(0xFFEF4444);
      case 'view':
        return const Color(0xFF6B7280);
      case 'approve':
        return AppColors.green;
      default:
        return Colors.grey;
    }
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
                          'Audit Log',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'System activity history',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () => _fetchAuditLogs(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading && _auditLogs.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: List.generate(
                        5,
                        (index) => const ShimmerAuditLogItem(),
                      ),
                    )
                  : _auditLogs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description_outlined,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No audit logs found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _fetchAuditLogs(refresh: true),
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount:
                                _auditLogs.length + (_nextUrl != null ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _auditLogs.length) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: _isLoadingMore
                                        ? const CircularProgressIndicator.adaptive()
                                        : const SizedBox.shrink(),
                                  ),
                                );
                              }
                              final log = _auditLogs[index];
                              return _AuditLogItemWidget(
                                log: log,
                                icon: _getActionIcon(log.actionType),
                                iconColor: _getActionColor(log.actionType),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SuperAdminBottomNavBar(currentIndex: 2),
    );
  }
}

class _AuditLogItemWidget extends StatelessWidget {
  final AuditLogItem log;
  final IconData icon;
  final Color iconColor;

  const _AuditLogItemWidget({
    required this.log,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        log.description ?? 'No description',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        log.actionType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (log.tableName != null && log.tableName!.isNotEmpty) ...[
                  Text(
                    'Table: ${log.tableName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  DateFormatter.formatDisplayDate(log.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
