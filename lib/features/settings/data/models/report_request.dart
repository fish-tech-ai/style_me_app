import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/settings/data/models/report_category.dart';

part 'report_request.g.dart';

@JsonSerializable()
class ReportRequest {
  final String message;
  final ReportCategory category;

  ReportRequest(this.message, this.category);

  factory ReportRequest.fromJson(Map<String, dynamic> json) {
    return _$ReportRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReportRequestToJson(this);
}
