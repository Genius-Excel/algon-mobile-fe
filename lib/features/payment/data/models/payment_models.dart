import 'package:json_annotation/json_annotation.dart';

part 'payment_models.g.dart';

@JsonSerializable()
class InitiatePaymentRequest {
  @JsonKey(name: 'payment_type')
  final String paymentType;
  @JsonKey(name: 'application_id')
  final String applicationId;
  @JsonKey(includeIfNull: false)
  final int? amount;

  const InitiatePaymentRequest({
    required this.paymentType,
    required this.applicationId,
    this.amount,
  });

  Map<String, dynamic> toJson() {
    final json = _$InitiatePaymentRequestToJson(this);
    // Ensure amount is always an integer (not double) if present
    if (json.containsKey('amount') && json['amount'] != null) {
      json['amount'] = (json['amount'] as num).toInt();
    }
    return json;
  }

  factory InitiatePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$InitiatePaymentRequestFromJson(json);
}

@JsonSerializable()
class PaymentData {
  @JsonKey(name: 'authorization_url')
  final String authorizationUrl;
  @JsonKey(name: 'access_code')
  final String accessCode;
  final String reference;

  const PaymentData({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDataToJson(this);
}

@JsonSerializable()
class InitiatePaymentResponse {
  final String message;
  final PaymentResponseData data;

  const InitiatePaymentResponse({
    required this.message,
    required this.data,
  });

  factory InitiatePaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$InitiatePaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InitiatePaymentResponseToJson(this);
}

@JsonSerializable()
class PaymentResponseData {
  final bool status;
  final String message;
  final PaymentData data;

  const PaymentResponseData({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PaymentResponseData.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseDataToJson(this);
}

