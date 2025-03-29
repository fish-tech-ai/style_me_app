import 'package:flutter/material.dart';
import 'package:style_me/core/app/data/app_repository.dart';

class SetLanguageUseCase {
  final AppRepository appRepository;

  SetLanguageUseCase(this.appRepository);

  void call(Locale language) {
    return appRepository.saveLanguage(language);
  }
}