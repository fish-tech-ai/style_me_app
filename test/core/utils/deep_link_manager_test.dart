import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_links/app_links.dart';
import 'package:style_me/core/utils/deep_link_manager.dart';

import 'deep_link_manager_test.mocks.dart';

@GenerateMocks([AppLinks])
void main() {
  late MockAppLinks mockAppLinks;
  late DeepLinkManager deepLinkManager;
  late StreamController<Uri> uriStreamController;
  late String validToken;

  setUp(() {
    final int futureTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
    validToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.${base64Url.encode(utf8.encode('{"exp":$futureTime}'))}.signature';
    mockAppLinks = MockAppLinks();
    deepLinkManager = DeepLinkManager(mockAppLinks);
    uriStreamController = StreamController<Uri>.broadcast();

    when(mockAppLinks.uriLinkStream)
        .thenAnswer((_) => uriStreamController.stream);
  });

  tearDown(() {
    uriStreamController.close();
  });

  group('DeepLinkManager', () {
    test(
        'should navigate to email confirmation when deep link is for email confirmation',
        () async {
      final Uri emailConfirmUri =
          Uri.parse('https://example.com/confirm-email?token=$validToken');
      navigateToPasswordReset(String token) =>
          fail('Should not navigate to password reset');
      final onEmailConfirmDeepLink = expectAsync1((String token) {
        expect(token, validToken);
      });
      onConfirmationFailed() => fail('Should not fail confirmation');

      await deepLinkManager.initializeAndHandleDeepLinks(
        navigateToPasswordReset,
        onEmailConfirmDeepLink,
        onConfirmationFailed,
      );
      uriStreamController.add(emailConfirmUri);
    });

    test(
        'should navigate to password reset when deep link is for password reset',
        () async {
      final Uri resetPasswordUri =
          Uri.parse('https://example.com/reset-password?token=$validToken');
      final navigateToPasswordReset = expectAsync1((String token) {
        expect(token, validToken);
      });
      onEmailConfirmDeepLink(String token) =>
          fail('Should not navigate to email confirmation');
      onConfirmationFailed() => fail('Should not fail confirmation');

      await deepLinkManager.initializeAndHandleDeepLinks(
        navigateToPasswordReset,
        onEmailConfirmDeepLink,
        onConfirmationFailed,
      );
      uriStreamController.add(resetPasswordUri);
    });

    test('should call onConfirmationFailed when token is missing', () async {
      final Uri invalidUri = Uri.parse('https://example.com/confirm-email');
      navigateToPasswordReset(String token) =>
          fail('Should not navigate to password reset');
      onEmailConfirmDeepLink(String token) =>
          fail('Should not navigate to email confirmation');
      final onConfirmationFailed = expectAsync0(() {});

      await deepLinkManager.initializeAndHandleDeepLinks(
        navigateToPasswordReset,
        onEmailConfirmDeepLink,
        onConfirmationFailed,
      );
      uriStreamController.add(invalidUri);
    });

    test('should call onConfirmationFailed when token is expired', () async {
      String expiredToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.${base64Url.encode(utf8.encode('{"exp":${1000000}}'))}.signature';

      final Uri expiredTokenUri =
          Uri.parse('https://example.com/confirm-email?token=$expiredToken');
      navigateToPasswordReset(String token) =>
          fail('Should not navigate to password reset');
      onEmailConfirmDeepLink(String token) =>
          fail('Should not navigate to email confirmation');
      final onConfirmationFailed = expectAsync0(() {});

      await deepLinkManager.initializeAndHandleDeepLinks(
        navigateToPasswordReset,
        onEmailConfirmDeepLink,
        onConfirmationFailed,
      );
      uriStreamController.add(expiredTokenUri);
    });

    test('should handle URI stream errors gracefully', () async {
      navigateToPasswordReset(String token) =>
          fail('Should not navigate to password reset');
      onEmailConfirmDeepLink(String token) =>
          fail('Should not navigate to email confirmation');
      onConfirmationFailed() => fail('Should not fail confirmation');

      await deepLinkManager.initializeAndHandleDeepLinks(
        navigateToPasswordReset,
        onEmailConfirmDeepLink,
        onConfirmationFailed,
      );
      uriStreamController.addError('Stream Error');
    });
  });
}
