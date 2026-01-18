import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/core/enums/payment_status.dart';
import 'package:algon_mobile/shared/widgets/bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/features/application/data/models/application_list_models.dart';
import 'package:algon_mobile/features/application/data/models/certificate_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';
import 'package:algon_mobile/core/router/router.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:algon_mobile/core/dependency_injection/di_providers.dart';

@RoutePage(name: 'Tracking')
class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  int _selectedTab = 0; // 0 = Certificate, 1 = Digitization, 2 = Certificates

  // Certificate applications
  bool _isLoadingCertificate = true;
  bool _isLoadingMoreCertificate = false;
  List<ApplicationItem> _certificateApplications = [];
  String? _nextUrlCertificate;
  final ScrollController _certificateScrollController = ScrollController();

  // Digitization applications
  bool _isLoadingDigitization = true;
  bool _isLoadingMoreDigitization = false;
  List<ApplicationItem> _digitizationApplications = [];
  String? _nextUrlDigitization;
  final ScrollController _digitizationScrollController = ScrollController();

  // Certificates
  bool _isLoadingCertificates = true;
  List<CertificateItem> _certificates = [];
  final ScrollController _certificatesScrollController = ScrollController();

  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _certificateScrollController.addListener(_onCertificateScroll);
    _digitizationScrollController.addListener(_onDigitizationScroll);
    _certificatesScrollController.addListener(_onCertificatesScroll);
    _fetchCertificateApplications();
    _fetchDigitizationApplications();
    _fetchCertificates();
  }

  @override
  void dispose() {
    _certificateScrollController.dispose();
    _digitizationScrollController.dispose();
    _certificatesScrollController.dispose();
    super.dispose();
  }

  void _onCertificateScroll() {
    if (_certificateScrollController.position.pixels >=
            _certificateScrollController.position.maxScrollExtent * 0.8 &&
        _nextUrlCertificate != null &&
        !_isLoadingMoreCertificate) {
      _loadMoreCertificateApplications();
    }
  }

  void _onDigitizationScroll() {
    if (_digitizationScrollController.position.pixels >=
            _digitizationScrollController.position.maxScrollExtent * 0.8 &&
        _nextUrlDigitization != null &&
        !_isLoadingMoreDigitization) {
      _loadMoreDigitizationApplications();
    }
  }

  void _onCertificatesScroll() {
    // Certificates don't have pagination, so no action needed
  }

  Future<void> _fetchCertificateApplications({bool refresh = false}) async {
    if (refresh) {
      _nextUrlCertificate = null;
      _certificateApplications.clear();
    }

    setState(() {
      _isLoadingCertificate = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final offset = refresh || _certificateApplications.isEmpty
          ? 0
          : _certificateApplications.length;
      final result = await applicationRepo.getMyApplications(
        applicationType: 'certificate',
        limit: _pageSize,
        offset: offset,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              final updatedList = refresh
                  ? List<ApplicationItem>.from(response.data.results)
                  : List<ApplicationItem>.from(_certificateApplications)
                ..addAll(response.data.results);
              updatedList.sort((a, b) {
                try {
                  final dateA = DateTime.parse(a.createdAt);
                  final dateB = DateTime.parse(b.createdAt);
                  return dateB.compareTo(dateA);
                } catch (e) {
                  return 0;
                }
              });
              _certificateApplications = updatedList;
              _nextUrlCertificate = response.data.next;
              _isLoadingCertificate = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingCertificate = false;
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
      setState(() {
        _isLoadingCertificate = false;
      });
      if (mounted) {
        Toast.error('An unexpected error occurred: ${e.toString()}', context);
      }
    }
  }

  Future<void> _loadMoreCertificateApplications() async {
    if (_nextUrlCertificate == null || _isLoadingMoreCertificate) return;

    setState(() {
      _isLoadingMoreCertificate = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final result = await applicationRepo.getMyApplications(
        applicationType: 'certificate',
        limit: _pageSize,
        offset: _certificateApplications.length,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              final updatedList =
                  List<ApplicationItem>.from(_certificateApplications)
                    ..addAll(response.data.results);
              updatedList.sort((a, b) {
                try {
                  final dateA = DateTime.parse(a.createdAt);
                  final dateB = DateTime.parse(b.createdAt);
                  return dateB.compareTo(dateA);
                } catch (e) {
                  return 0;
                }
              });
              _certificateApplications = updatedList;
              _nextUrlCertificate = response.data.next;
              _isLoadingMoreCertificate = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingMoreCertificate = false;
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoadingMoreCertificate = false;
      });
    }
  }

  Future<void> _fetchDigitizationApplications({bool refresh = false}) async {
    if (refresh) {
      _nextUrlDigitization = null;
      _digitizationApplications.clear();
    }

    setState(() {
      _isLoadingDigitization = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final offset = refresh || _digitizationApplications.isEmpty
          ? 0
          : _digitizationApplications.length;
      final result = await applicationRepo.getMyApplications(
        applicationType: 'digitization',
        limit: _pageSize,
        offset: offset,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              final updatedList = refresh
                  ? List<ApplicationItem>.from(response.data.results)
                  : List<ApplicationItem>.from(_digitizationApplications)
                ..addAll(response.data.results);
              updatedList.sort((a, b) {
                try {
                  final dateA = DateTime.parse(a.createdAt);
                  final dateB = DateTime.parse(b.createdAt);
                  return dateB.compareTo(dateA);
                } catch (e) {
                  return 0;
                }
              });
              _digitizationApplications = updatedList;
              _nextUrlDigitization = response.data.next;
              _isLoadingDigitization = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingDigitization = false;
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
      setState(() {
        _isLoadingDigitization = false;
      });
      if (mounted) {
        Toast.error('An unexpected error occurred: ${e.toString()}', context);
      }
    }
  }

  Future<void> _loadMoreDigitizationApplications() async {
    if (_nextUrlDigitization == null || _isLoadingMoreDigitization) return;

    setState(() {
      _isLoadingMoreDigitization = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final result = await applicationRepo.getMyApplications(
        applicationType: 'digitization',
        limit: _pageSize,
        offset: _digitizationApplications.length,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              final updatedList =
                  List<ApplicationItem>.from(_digitizationApplications)
                    ..addAll(response.data.results);
              updatedList.sort((a, b) {
                try {
                  final dateA = DateTime.parse(a.createdAt);
                  final dateB = DateTime.parse(b.createdAt);
                  return dateB.compareTo(dateA);
                } catch (e) {
                  return 0;
                }
              });
              _digitizationApplications = updatedList;
              _nextUrlDigitization = response.data.next;
              _isLoadingMoreDigitization = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingMoreDigitization = false;
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoadingMoreDigitization = false;
      });
    }
  }

  Future<void> _fetchCertificates({bool refresh = false}) async {
    if (refresh) {
      _certificates.clear();
    }

    setState(() {
      _isLoadingCertificates = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final result = await applicationRepo.getMyCertificates();

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _certificates = List<CertificateItem>.from(response.data)
                ..sort((a, b) {
                  try {
                    final dateA = DateTime.parse(a.createdAt);
                    final dateB = DateTime.parse(b.createdAt);
                    return dateB.compareTo(dateA);
                  } catch (e) {
                    return 0;
                  }
                });
              _isLoadingCertificates = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingCertificates = false;
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
      setState(() {
        _isLoadingCertificates = false;
      });
      if (mounted) {
        Toast.error('An unexpected error occurred: ${e.toString()}', context);
      }
    }
  }

  Future<void> _downloadCertificate(CertificateItem certificate) async {
    if (certificate.filePath == null || certificate.filePath!.isEmpty) {
      Toast.error('Certificate file not available', context);
      return;
    }

    try {
      final dio = ref.read(dioProvider);
      final tempDir = await getTemporaryDirectory();
      final fileName = '${certificate.certificateNumber}.pdf';
      final filePath = '${tempDir.path}/$fileName';

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );

      await dio.download(
        certificate.filePath!,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      // Hide loading indicator
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Share the file
      if (mounted) {
        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'Certificate: ${certificate.certificateNumber}',
        );
        Toast.success('Certificate downloaded', context);
      }
    } catch (e) {
      // Hide loading indicator
      if (mounted) {
        Navigator.of(context).pop();
        Toast.error('Failed to download certificate: ${e.toString()}', context);
      }
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              child: const Row(
                children: [
                  Text(
                    'Application Tracking',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Application Tracking content
            Expanded(
              child: Container(
                color: const Color(0xFFF9FAFB),
                child: Column(
                  children: [
                    // Tab bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTab('Certification', 0),
                        _buildTab('Digitization', 1),
                        _buildTab('Certificates', 2),
                      ],
                    ),
                    // Applications list
                    Expanded(
                      child: Container(
                        color: const Color(0xFFF9FAFB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            Expanded(
                              child: _selectedTab == 0
                                  ? _buildCertificateList()
                                  : _selectedTab == 1
                                      ? _buildDigitizationList()
                                      : _buildCertificatesList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF9FAFB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.gradientEnd : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: const Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateList() {
    if (_isLoadingCertificate && _certificateApplications.isEmpty) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < 4 ? 16 : 0),
            child: const ShimmerApplicationCard(),
          );
        },
      );
    }

    if (_certificateApplications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No certificate applications found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchCertificateApplications(refresh: true),
      child: ListView.builder(
        controller: _certificateScrollController,
        itemCount: _certificateApplications.length +
            (_isLoadingMoreCertificate ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _certificateApplications.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator.adaptive()),
              ),
            );
          }
          final application = _certificateApplications[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _certificateApplications.length - 1 ? 16 : 0,
            ),
            child: _TrackingCard(
              application: application,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDigitizationList() {
    if (_isLoadingDigitization && _digitizationApplications.isEmpty) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < 4 ? 16 : 0),
            child: const ShimmerApplicationCard(),
          );
        },
      );
    }

    if (_digitizationApplications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No digitization applications found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchDigitizationApplications(refresh: true),
      child: ListView.builder(
        controller: _digitizationScrollController,
        itemCount: _digitizationApplications.length +
            (_isLoadingMoreDigitization ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _digitizationApplications.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          final application = _digitizationApplications[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _digitizationApplications.length - 1 ? 16 : 0,
            ),
            child: _TrackingCard(
              application: application,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCertificatesList() {
    if (_isLoadingCertificates && _certificates.isEmpty) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < 4 ? 16 : 0),
            child: const ShimmerApplicationCard(),
          );
        },
      );
    }

    if (_certificates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No certificates found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchCertificates(refresh: true),
      child: ListView.builder(
        controller: _certificatesScrollController,
        itemCount: _certificates.length,
        itemBuilder: (context, index) {
          final certificate = _certificates[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _certificates.length - 1 ? 16 : 0,
            ),
            child: _CertificateCard(
              certificate: certificate,
              onDownload: () => _downloadCertificate(certificate),
            ),
          );
        },
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final CertificateItem certificate;
  final VoidCallback onDownload;

  const _CertificateCard({
    required this.certificate,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final canDownload = certificate.isDownloadable == true &&
        certificate.filePath != null &&
        certificate.filePath!.isNotEmpty;

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
                      certificate.certificateType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                        "Certificate ID : ${certificate.certificateNumber.toUpperCase()}"),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Issued Date: ${DateFormatter.formatDisplayDate(certificate.issueDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    // if (certificate.expiryDate != null) ...[
                    //   const SizedBox(height: 4),
                    //   Text(
                    //     'Expiry Date: ${DateFormatter.formatDisplayDate(certificate.expiryDate!)}',
                    //     style: const TextStyle(
                    //       fontSize: 12,
                    //       color: Color(0xFF6B7280),
                    //     ),
                    //   ),
                    // ],
                  ],
                ),
              ),
              if (certificate.isRevoked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel, size: 16, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        'Revoked',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              CustomButton(
                backgroundColor: canDownload ? Colors.greenAccent : Colors.grey,
                text: 'Download',
                iconData: Icons.download,
                iconPosition: IconPosition.left,
                onPressed: onDownload,
                variant: ButtonVariant.primary,
                fontSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _TrackingCard extends StatelessWidget {
  final ApplicationItem application;

  const _TrackingCard({
    required this.application,
  });

  ApplicationStatus get _status {
    return ApplicationStatus.fromString(application.applicationStatus);
  }

  PaymentStatus get _paymentStatus {
    return PaymentStatus.fromString(application.paymentStatus);
  }

  String get _location {
    return '${application.localGovernment.name}, ${application.state.name}';
  }

  bool get _hasDownloadButton {
    return _status == ApplicationStatus.approved ||
        _status == ApplicationStatus.digitized;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(
          ApplicationDetailRoute(id: application.id),
        );
      },
      child: Container(
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
                        application.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIN: ${application.nin}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormatter.formatDisplayDate(application.createdAt),
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
                    color: _status.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_status.icon, size: 16, color: _status.color),
                      const SizedBox(width: 6),
                      Text(
                        _status.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _status.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_paymentStatus == PaymentStatus.successful) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _paymentStatus.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_paymentStatus.icon,
                        size: 12, color: _paymentStatus.color),
                    const SizedBox(width: 4),
                    Text(
                      _paymentStatus.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _paymentStatus.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_hasDownloadButton) ...[
              const SizedBox(height: 12),
              CustomButton(
                text: 'Download',
                iconData: Icons.download,
                iconPosition: IconPosition.left,
                onPressed: () {
                  // TODO: Implement download functionality
                },
                variant: ButtonVariant.primary,
                fontSize: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
