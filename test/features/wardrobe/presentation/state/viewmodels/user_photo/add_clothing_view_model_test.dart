import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/core/network/failures/image_process_failure.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_user_photo_response.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/clear_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/confirm_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/send_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/user_photo/add_user_photo_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

import '../../../../../../helpers/shared_test_functions.dart';

class MockSendUserPhotoUseCase extends Mock implements SendUserPhotoUseCase {}

class MockConfirmUserPhotoUseCase extends Mock
    implements ConfirmUserPhotoUseCase {}

class MockDeleteUserPhotoUseCase extends Mock
    implements ClearUserPhotoUseCase {}

void main() {
  late MockSendUserPhotoUseCase mockSend;
  late MockConfirmUserPhotoUseCase mockConfirm;
  late MockDeleteUserPhotoUseCase mockDelete;
  late MockAppGlobalViewModel mockGlobal;
  late ProviderContainer container;

  setUp(() {
    mockSend = MockSendUserPhotoUseCase();
    mockConfirm = MockConfirmUserPhotoUseCase();
    mockDelete = MockDeleteUserPhotoUseCase();
    mockGlobal = MockAppGlobalViewModel();

    container = ProviderContainer(
      overrides: [
        addUserPhotoViewModelProvider.overrideWith(
          () => AddUserPhotoViewModel.test(
            mockSend,
            mockConfirm,
            mockDelete,
          ),
        ),
        appGlobalViewModelProvider.overrideWith(() => mockGlobal),
      ],
    );
    registerFallbackValue(ServerFailure("", 404));
    registerFallbackValue(File("file.txt"));
    addTearDown(container.dispose);
  });

  test('onImageFetched sets image and mode', () {
    final file = File('test.jpg');
    final notifier = container.read(addUserPhotoViewModelProvider.notifier);

    notifier.onImageFetched(file);

    final state = container.read(addUserPhotoViewModelProvider);
    expect(state.image, file);
    expect(state.addPhotoPageMode, AddPhotoPageMode.acceptPhoto);
  });

  test('sendUserPhoto sets state on success', () async {
    final file = File('image.jpg');
    final response = SendUserPhotoResponse('abc123');

    when(() => mockSend.call(file))
        .thenAnswer((_) async => Result.success(response));

    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    notifier.onImageFetched(file);
    await notifier.sendUserPhoto(file);

    final state = container.read(addUserPhotoViewModelProvider);

    expect(state.isImageAddLoading, false);
    expect(state.addPhotoPageMode, AddPhotoPageMode.fillData);
  });

  test('sendUserPhoto handles ImageProcessFailure', () async {
    final file = File('image.jpg');
    final failure =
        ImageProcessFailure("", ImageErrorTypeEnum.NO_PERSON_ON_IMAGE);

    when(() => mockSend.call(file))
        .thenAnswer((_) async => Result.fail(failure));

    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    await notifier.sendUserPhoto(file);

    final state = container.read(addUserPhotoViewModelProvider);

    expect(state.isImageAddLoading, false);
    expect(state.imageProcessingError, ImageErrorTypeEnum.NO_PERSON_ON_IMAGE);
  });

  test('sendUserPhoto handles generic failure with showFailure', () async {
    final file = File('image.jpg');
    final failure = ServerFailure("Generic", 500);

    when(() => mockSend.call(file))
        .thenAnswer((_) async => Result.fail(failure));

    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    await notifier.sendUserPhoto(file);

    verify(() => mockGlobal.showFailure(failure)).called(1);
    expect(
        container.read(addUserPhotoViewModelProvider).isImageAddLoading, false);
  });

  test('sendConfirmationData calls onSuccess on success', () async {
    const imageId = "abc123";
    when(() => mockSend.call(any())).thenAnswer(
        (_) async => Result.success(SendUserPhotoResponse(imageId)));
    when(() => mockConfirm.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success(null));

    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    await notifier.sendUserPhoto(File('file.jpg'));

    var called = false;
    await notifier.sendConfirmationData(() {
      called = true;
    });

    expect(called, true);
    expect(
        container.read(addUserPhotoViewModelProvider).isImageAddLoading, false);
  });

  test('sendConfirmationData calls showFailure on failure', () async {
    when(() => mockConfirm.call(any(), any(), any()))
        .thenAnswer((_) async => Result.fail(ServerFailure('fail', 500)));

    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    await notifier.sendConfirmationData(() {});

    verify(() => mockGlobal.showFailure(any())).called(1);
  });

  test('onTextChanged updates User form', () {
    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    notifier.onTextChanged("Jacket");

    final state = container.read(addUserPhotoViewModelProvider);
    expect(state.userPhotoForm.nameText, "Jacket");
  });

  test('onIsDefault updates form', () {
    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    notifier.onIsDefaultChanged(true);

    final state = container.read(addUserPhotoViewModelProvider);
    expect(state.userPhotoForm.isDefault, true);
  });

  test('onBackAction clears state or pops', () async {
    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    notifier.onImageFetched(File('dummy.jpg'));

    notifier.onBackAction();

    final state = container.read(addUserPhotoViewModelProvider);
    expect(state.addPhotoPageMode, AddPhotoPageMode.pickPhoto);
    expect(state.image, null);
  });

  test('clearImageData calls deleteUserPhotoUseCase if imageId exists',
      () async {
    const imageId = "abc123";
    when(() => mockSend.call(any())).thenAnswer((_) async =>
        Result.success(SendUserPhotoResponse(imageId)));
    when(() => mockDelete.call(imageId))
        .thenAnswer((_) async => Result.success(null));

    final notifier = container.read(addUserPhotoViewModelProvider.notifier);
    await notifier.sendUserPhoto(File('dummy.jpg'));

    await notifier.clearImageData();
    verify(() => mockDelete.call(imageId)).called(1);
  });
}
