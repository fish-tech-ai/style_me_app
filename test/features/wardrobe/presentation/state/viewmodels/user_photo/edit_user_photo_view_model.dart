import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/delete_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_original_user_image_url_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/update_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/user_photo/edit_user_photo_view_model.dart';

import '../../../../../../helpers/shared_test_functions.dart';

class MockDeleteUserPhotoUseCase extends Mock
    implements DeleteUserPhotoUseCase {}

class MockUpdateUserPhotoUseCase extends Mock
    implements UpdateUserPhotoUseCase {}

class MockGetOriginalUserImageUrlUseCase extends Mock
    implements GetOriginalUserImageUrlUseCase {}

class MockImageFetcher extends Mock implements ImageFetcher {}

class FakeUserPhoto extends Fake implements UserPhoto {}

void main() {
  late MockDeleteUserPhotoUseCase mockDelete;
  late MockUpdateUserPhotoUseCase mockUpdate;
  late MockGetOriginalUserImageUrlUseCase mockGetUrl;
  late MockImageFetcher mockFetcher;
  late MockAppGlobalViewModel mockGlobal;
  late ProviderContainer container;

  final userPhoto = UserPhoto("id123", "Profile", "url", isDefault: false);

  setUpAll(() {
    mockGetTemporaryDirectory();
    registerFallbackValue(ServerFailure("fail", 500));
    registerFallbackValue(userPhoto);
  });

  setUp(() {
    mockDelete = MockDeleteUserPhotoUseCase();
    mockUpdate = MockUpdateUserPhotoUseCase();
    mockGetUrl = MockGetOriginalUserImageUrlUseCase();
    mockFetcher = MockImageFetcher();
    mockGlobal = MockAppGlobalViewModel();

    container = ProviderContainer(overrides: [
      editUserPhotoViewModelProvider
          .overrideWith(() => EditUserPhotoViewModel.test(
                mockDelete,
                mockUpdate,
                mockGetUrl,
                mockFetcher,
              )),
      appGlobalViewModelProvider.overrideWith(() => mockGlobal),
    ]);

    addTearDown(container.dispose);
  });

  test('init loads image and sets state on success', () async {
    final signedUrl = "http://example.com/photo.webp";
    final response = OriginalImageUrlResponse(signedUrl);
    when(() => mockGetUrl.call(userPhoto.id))
        .thenAnswer((_) async => Result.success(response));
    when(() => mockFetcher.downloadAndCacheImage(any(), any()))
        .thenAnswer((_) async {});

    final notifier = container.read(editUserPhotoViewModelProvider.notifier);
    await notifier.init(userPhoto);

    await untilCalled(() => mockFetcher.downloadAndCacheImage(any(), any()));

    final state = container.read(editUserPhotoViewModelProvider);
    expect(state.isPageLoading, false);
    expect(state.originalImagePath, contains("${userPhoto.id}_original.webp"));
  });

  test('init calls showFailure on error', () async {
    when(() => mockGetUrl.call(userPhoto.id))
        .thenAnswer((_) async => Result.fail(ServerFailure("error", 500)));

    final notifier = container.read(editUserPhotoViewModelProvider.notifier);
    await notifier.init(userPhoto);

    verify(() => mockGlobal.showFailure(any())).called(1);
    expect(container.read(editUserPhotoViewModelProvider).isPageLoading, false);
  });

  test('deleteUserPhoto success calls onSuccess', () async {
    when(() => mockDelete.call(userPhoto.id))
        .thenAnswer((_) async => Result.success(null));

    final notifier = container.read(editUserPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(userPhoto: userPhoto);

    var called = false;
    await notifier.deleteUserPhoto(() {
      called = true;
    });

    expect(called, true);
    expect(
        container.read(editUserPhotoViewModelProvider).isDeleteLoading, false);
  });

  test('deleteUserPhoto failure calls showFailure', () async {
    when(() => mockDelete.call(any()))
        .thenAnswer((_) async => Result.fail(ServerFailure("fail", 500)));

    final notifier = container.read(editUserPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(userPhoto: userPhoto);

    await notifier.deleteUserPhoto(() {});

    verify(() => mockGlobal.showFailure(any())).called(1);
    expect(
        container.read(editUserPhotoViewModelProvider).isDeleteLoading, false);
  });

  test('updateUserPhoto success calls onSuccess with updated userPhoto',
      () async {
    when(() => mockUpdate.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success(null));

    final notifier = container.read(editUserPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(userPhoto: userPhoto);

    var called = false;
    await notifier.updateUserPhoto((updated) {
      called = true;
      expect(updated.name, userPhoto.name);
    });

    expect(called, true);
    expect(container.read(editUserPhotoViewModelProvider).isSaveLoading, false);
  });

  test('updateUserPhoto failure calls showFailure', () async {
    when(() => mockUpdate.call(any(), any(), any()))
        .thenAnswer((_) async => Result.fail(ServerFailure("fail", 500)));

    final notifier = container.read(editUserPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(userPhoto: userPhoto);

    await notifier.updateUserPhoto((_) {});

    verify(() => mockGlobal.showFailure(any())).called(1);
    expect(container.read(editUserPhotoViewModelProvider).isSaveLoading, false);
  });

  test('onNameTextChanged updates user photo name', () {
    final notifier = container.read(editUserPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(userPhoto: userPhoto);

    notifier.onNameTextChanged("New Name");

    expect(container.read(editUserPhotoViewModelProvider).userPhoto.name,
        "New Name");
  });

  test('onIsDefaultChanged updates user photo default flag', () {
    final notifier = container.read(editUserPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(userPhoto: userPhoto);

    notifier.onIsDefaultChanged(true);

    expect(container.read(editUserPhotoViewModelProvider).userPhoto.isDefault,
        true);
  });
}
