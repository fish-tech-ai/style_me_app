import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/settings/data/models/report_request.dart';
import 'package:style_me/features/settings/data/settings_repository.dart';

class AddReportUseCase {
  final SettingsRepository repository;
  final NetworkRequestUtil networkUtil;

  AddReportUseCase(this.repository, this.networkUtil);

  Future<Result> call(ReportRequest request) {
    return networkUtil
        .makeRepositoryRequest(() => repository.addReport(request));
  }
}
