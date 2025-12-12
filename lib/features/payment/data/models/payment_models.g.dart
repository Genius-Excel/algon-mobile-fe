// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiatePaymentRequest _$InitiatePaymentRequestFromJson(
        Map<String, dynamic> json) =>
    InitiatePaymentRequest(
      paymentType: json['payment_type'] as String,
      applicationId: json['application_id'] as String,
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InitiatePaymentRequestToJson(
    InitiatePaymentRequest instance) {
  final val = <String, dynamic>{
    'payment_type': instance.paymentType,
    'application_id': instance.applicationId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('amount', instance.amount);
  return val;
}

PaymentData _$PaymentDataFromJson(Map<String, dynamic> json) => PaymentData(
      authorizationUrl: json['authorization_url'] as String,
      accessCode: json['access_code'] as String,
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$PaymentDataToJson(PaymentData instance) =>
    <String, dynamic>{
      'authorization_url': instance.authorizationUrl,
      'access_code': instance.accessCode,
      'reference': instance.reference,
    };

InitiatePaymentResponse _$InitiatePaymentResponseFromJson(
        Map<String, dynamic> json) =>
    InitiatePaymentResponse(
      message: json['message'] as String,
      data: PaymentResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InitiatePaymentResponseToJson(
        InitiatePaymentResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

PaymentResponseData _$PaymentResponseDataFromJson(Map<String, dynamic> json) =>
    PaymentResponseData(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: PaymentData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentResponseDataToJson(
        PaymentResponseData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
