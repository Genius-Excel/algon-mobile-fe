import 'package:json_annotation/json_annotation.dart';

part 'lga_fee_models.g.dart';

@JsonSerializable()
class LGAFeeData {
  final String id;
  @JsonKey(name: 'application_fee')
  final String applicationFee;
  @JsonKey(name: 'digitization_fee')
  final String digitizationFee;
  @JsonKey(name: 'regeneration_fee')
  final String regenerationFee;
  final String currency;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'local_government')
  final String localGovernment;
  @JsonKey(name: 'last_updated_by')
  final String? lastUpdatedBy;
  final String state;

  const LGAFeeData({
    required this.id,
    required this.applicationFee,
    required this.digitizationFee,
    required this.regenerationFee,
    required this.currency,
    required this.updatedAt,
    required this.localGovernment,
    this.lastUpdatedBy,
    required this.state,
  });

  factory LGAFeeData.fromJson(Map<String, dynamic> json) =>
      _$LGAFeeDataFromJson(json);

  Map<String, dynamic> toJson() => _$LGAFeeDataToJson(this);
}

@JsonSerializable()
class LGAFeeResponse {
  final String message;
  final List<LGAFeeData> data;

  const LGAFeeResponse({
    required this.message,
    required this.data,
  });

  factory LGAFeeResponse.fromJson(Map<String, dynamic> json) =>
      _$LGAFeeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LGAFeeResponseToJson(this);
}

@JsonSerializable()
class CreateLGAFeeRequest {
  @JsonKey(name: 'application_fee')
  final double applicationFee;
  @JsonKey(name: 'digitization_fee')
  final double digitizationFee;
  @JsonKey(name: 'regeneration_fee')
  final double regenerationFee;

  const CreateLGAFeeRequest({
    required this.applicationFee,
    required this.digitizationFee,
    required this.regenerationFee,
  });

  Map<String, dynamic> toJson() => _$CreateLGAFeeRequestToJson(this);

  factory CreateLGAFeeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateLGAFeeRequestFromJson(json);
}
