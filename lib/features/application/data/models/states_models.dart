import 'package:json_annotation/json_annotation.dart';

part 'states_models.g.dart';

@JsonSerializable()
class LocalGovernment {
  final String id;
  final String name;

  const LocalGovernment({
    required this.id,
    required this.name,
  });

  factory LocalGovernment.fromJson(Map<String, dynamic> json) =>
      _$LocalGovernmentFromJson(json);

  Map<String, dynamic> toJson() => _$LocalGovernmentToJson(this);
}

@JsonSerializable()
class StateData {
  final String id;
  final String name;
  final String? code;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'local_governtments')
  final List<LocalGovernment> localGovernments;

  const StateData({
    required this.id,
    required this.name,
    this.code,
    required this.createdAt,
    required this.updatedAt,
    required this.localGovernments,
  });

  factory StateData.fromJson(Map<String, dynamic> json) =>
      _$StateDataFromJson(json);

  Map<String, dynamic> toJson() => _$StateDataToJson(this);
}

@JsonSerializable()
class StatesResponse {
  final String message;
  final List<StateData> data;

  const StatesResponse({
    required this.message,
    required this.data,
  });

  factory StatesResponse.fromJson(Map<String, dynamic> json) =>
      _$StatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatesResponseToJson(this);
}

