import 'package:gal/gal.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/failures/failure.dart';

class GalFailure extends Failure {
  final GalExceptionType type;

  GalFailure(this.type, super.message);

  String getTranslatedText() {
    switch (type) {
      case GalExceptionType.accessDenied:
        return localizations.galTypeAccessDenied;
      case GalExceptionType.notEnoughSpace:
        return localizations.galTypeNotEnoughSpace;
      case GalExceptionType.notSupportedFormat:
        return localizations.galTypeNotSupportedFormat;
      case GalExceptionType.unexpected:
        return localizations.galTypeUnexpected;
    }
  }
}
