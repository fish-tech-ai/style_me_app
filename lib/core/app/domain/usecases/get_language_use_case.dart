import 'package:flutter/material.dart';
import 'package:style_me/core/app/data/app_repository.dart';

class GetLanguageUseCase {
  final AppRepository appRepository;

  GetLanguageUseCase(this.appRepository);

  Locale call() {
    return appRepository.getLanguage() ?? Locale('en');
  }
}