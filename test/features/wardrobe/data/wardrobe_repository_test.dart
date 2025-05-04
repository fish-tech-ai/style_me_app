import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/network/exceptions/expected_error_response.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/core/network/exceptions/image_process_exception.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/clothes_service.dart';
import 'package:style_me/core/network/services/user_photos_service.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_user_photo_response.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class MockClothesService extends Mock implements ClothesService {}

class MockUserPhotosService extends Mock implements UserPhotosService {}

base class MockResponse<T> extends Mock with MockResponseMixin<T> {}

void main() {
  late MockClothesService clothesService;
  late MockUserPhotosService userService;
  late WardrobeRepository repo;

  setUp(() {
    clothesService = MockClothesService();
    userService = MockUserPhotosService();
    repo = WardrobeRepository(clothesService, userService);
  });

  group('WardrobeRepository.sendClothingPhoto', () {
    test('returns response when successful', () async {
      final file = File('test/path.jpg');
      final response = MockResponse<SendClothingPhotoResponse>();
      final expected = SendClothingPhotoResponse("", ClothingCategoryEnum.ALL);

      when(() => response.isSuccessful).thenReturn(true);
      when(() => response.body).thenReturn(expected);
      when(() => clothesService.sendClothingPhoto(any()))
          .thenAnswer((_) async => response);

      final result = await repo.sendClothingPhoto(file);
      expect(result, expected);
    });

    test('throws ImageProcessException when error is ExpectedErrorResponse',
        () async {
      final file = File('test/path.jpg');
      final response = MockResponse<SendClothingPhotoResponse>();
      final errorResponse =
          ExpectedErrorResponse(ImageErrorTypeEnum.CANT_PROCESS);

      when(() => response.isSuccessful).thenReturn(false);
      when(() => response.error).thenReturn(errorResponse);
      when(() => clothesService.sendClothingPhoto(any()))
          .thenAnswer((_) async => response);

      expect(
        () => repo.sendClothingPhoto(file),
        throwsA(isA<ImageProcessException>()),
      );
    });

    test('throws ServerException for generic error', () async {
      final file = File('test/path.jpg');
      when(() => clothesService.sendClothingPhoto(any()))
          .thenThrow(Exception('network failed'));

      expect(
        () => repo.sendClothingPhoto(file),
        throwsA(isA<ServerException>()),
      );
    });

    test('rethrows ImageProcessException if already caught', () async {
      final file = File('test/path.jpg');

      Future<MockResponse<SendClothingPhotoResponse>> throwIt() async {
        throw ImageProcessException(ImageErrorTypeEnum.IMAGE_IS_NSFW);
      }

      when(() => clothesService.sendClothingPhoto(any()))
          .thenAnswer((_) async => throwIt());

      expect(
        () => repo.sendClothingPhoto(file),
        throwsA(isA<ImageProcessException>()),
      );
    });
  });

  group('WardrobeRepository.sendUserPhoto', () {
    test('returns response when successful', () async {
      final file = File('test/path.jpg');
      final response = MockResponse<SendUserPhotoResponse>();
      final expected = SendUserPhotoResponse("");

      when(() => response.isSuccessful).thenReturn(true);
      when(() => response.body).thenReturn(expected);
      when(() => userService.sendUserPhoto(any()))
          .thenAnswer((_) async => response);

      final result = await repo.sendUserPhoto(file);
      expect(result, expected);
    });

    test('throws ImageProcessException when error is ExpectedErrorResponse',
            () async {
          final file = File('test/path.jpg');
          final response = MockResponse<SendUserPhotoResponse>();
          final errorResponse =
          ExpectedErrorResponse(ImageErrorTypeEnum.CANT_PROCESS);

          when(() => response.isSuccessful).thenReturn(false);
          when(() => response.error).thenReturn(errorResponse);
          when(() => userService.sendUserPhoto(any()))
              .thenAnswer((_) async => response);

          expect(
                () => repo.sendUserPhoto(file),
            throwsA(isA<ImageProcessException>()),
          );
        });

    test('throws ServerException for generic error', () async {
      final file = File('test/path.jpg');
      when(() => userService.sendUserPhoto(any()))
          .thenThrow(Exception('network failed'));

      expect(
            () => repo.sendUserPhoto(file),
        throwsA(isA<ServerException>()),
      );
    });

    test('rethrows ImageProcessException if already caught', () async {
      final file = File('test/path.jpg');

      Future<MockResponse<SendUserPhotoResponse>> throwIt() async {
        throw ImageProcessException(ImageErrorTypeEnum.IMAGE_IS_NSFW);
      }

      when(() => userService.sendUserPhoto(any()))
          .thenAnswer((_) async => throwIt());

      expect(
            () => repo.sendUserPhoto(file),
        throwsA(isA<ImageProcessException>()),
      );
    });
  });
}
