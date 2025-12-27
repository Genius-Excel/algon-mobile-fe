// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminMetricCard _$AdminMetricCardFromJson(Map<String, dynamic> json) =>
    AdminMetricCard(
      value: (json['value'] as num).toInt(),
      trend: json['trend'] as String?,
      changePercent: (json['change_percent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AdminMetricCardToJson(AdminMetricCard instance) =>
    <String, dynamic>{
      'value': instance.value,
      'trend': instance.trend,
      'change_percent': instance.changePercent,
    };

AdminMetricCards _$AdminMetricCardsFromJson(Map<String, dynamic> json) =>
    AdminMetricCards(
      pendingApplications: AdminMetricCard.fromJson(
          json['pending_applications'] as Map<String, dynamic>),
      approvedCertificates: AdminMetricCard.fromJson(
          json['approved_certificates'] as Map<String, dynamic>),
      rejected:
          AdminMetricCard.fromJson(json['rejected'] as Map<String, dynamic>),
      totalRevenue: AdminMetricCard.fromJson(
          json['total_revenue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminMetricCardsToJson(AdminMetricCards instance) =>
    <String, dynamic>{
      'pending_applications': instance.pendingApplications,
      'approved_certificates': instance.approvedCertificates,
      'rejected': instance.rejected,
      'total_revenue': instance.totalRevenue,
    };

StateData _$StateDataFromJson(Map<String, dynamic> json) => StateData(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$StateDataToJson(StateData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

LocalGovernmentData _$LocalGovernmentDataFromJson(Map<String, dynamic> json) =>
    LocalGovernmentData(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LocalGovernmentDataToJson(
        LocalGovernmentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

RecentApplication _$RecentApplicationFromJson(Map<String, dynamic> json) =>
    RecentApplication(
      id: json['id'] as String,
      nin: json['nin'] as String,
      fullName: json['full_name'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      village: json['village'] as String,
      residentialAddress: json['residential_address'] as String?,
      landmark: json['landmark'] as String?,
      letterFromTraditionalRuler:
          json['letter_from_traditional_ruler'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      ninSlip: json['nin_slip'] as String?,
      applicationStatus: json['application_status'] as String,
      paymentStatus: json['payment_status'] as String,
      remarks: json['remarks'] as String?,
      approvedAt: json['approved_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      applicant: json['applicant'] as String,
      state: StateData.fromJson(json['state'] as Map<String, dynamic>),
      localGovernment: LocalGovernmentData.fromJson(
          json['local_government'] as Map<String, dynamic>),
      approvedBy: RecentApplication._approvedByFromJson(json['approved_by']),
    );

Map<String, dynamic> _$RecentApplicationToJson(RecentApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nin': instance.nin,
      'full_name': instance.fullName,
      'date_of_birth': instance.dateOfBirth,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'village': instance.village,
      'residential_address': instance.residentialAddress,
      'landmark': instance.landmark,
      'letter_from_traditional_ruler': instance.letterFromTraditionalRuler,
      'profile_photo': instance.profilePhoto,
      'nin_slip': instance.ninSlip,
      'application_status': instance.applicationStatus,
      'payment_status': instance.paymentStatus,
      'remarks': instance.remarks,
      'approved_at': instance.approvedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'applicant': instance.applicant,
      'state': instance.state,
      'local_government': instance.localGovernment,
      'approved_by': RecentApplication._approvedByToJson(instance.approvedBy),
    };

AdminDashboardData _$AdminDashboardDataFromJson(Map<String, dynamic> json) =>
    AdminDashboardData(
      metricCards: AdminMetricCards.fromJson(
          json['metric_cards'] as Map<String, dynamic>),
      weeklyApplications: (json['weekly_applications'] as num).toInt(),
      approvalStatistics: (json['approval_statistics'] as num).toInt(),
      recentApplications: (json['recent_applications'] as List<dynamic>)
          .map((e) => RecentApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdminDashboardDataToJson(AdminDashboardData instance) =>
    <String, dynamic>{
      'metric_cards': instance.metricCards,
      'weekly_applications': instance.weeklyApplications,
      'approval_statistics': instance.approvalStatistics,
      'recent_applications': instance.recentApplications,
    };

AdminDashboardResponse _$AdminDashboardResponseFromJson(
        Map<String, dynamic> json) =>
    AdminDashboardResponse(
      message: json['message'] as String,
      data: AdminDashboardData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminDashboardResponseToJson(
        AdminDashboardResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
