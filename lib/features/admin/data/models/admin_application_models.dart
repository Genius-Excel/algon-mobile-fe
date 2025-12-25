import 'package:json_annotation/json_annotation.dart';
import '../../../application/data/models/application_list_models.dart';

part 'admin_application_models.g.dart';

@JsonSerializable()
class UpdateApplicationStatusRequest {
  @JsonKey(name: 'application_type')
  final String applicationType;
  final String action; // 'approved' or 'rejected'

  const UpdateApplicationStatusRequest({
    required this.applicationType,
    required this.action,
  });

  factory UpdateApplicationStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateApplicationStatusRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateApplicationStatusRequestToJson(this);
}

@JsonSerializable()
class UpdateApplicationStatusResponse {
  final String message;
  @JsonKey(fromJson: _applicationItemFromJson, toJson: _applicationItemToJson)
  final ApplicationItem data;

  const UpdateApplicationStatusResponse({
    required this.message,
    required this.data,
  });

  factory UpdateApplicationStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateApplicationStatusResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateApplicationStatusResponseToJson(this);

  static ApplicationItem _applicationItemFromJson(Map<String, dynamic> json) =>
      ApplicationItem.fromJson(json);

  static Map<String, dynamic> _applicationItemToJson(ApplicationItem item) =>
      item.toJson();
}
