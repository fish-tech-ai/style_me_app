import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/core/network/failures/image_process_failure.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';
import 'package:style_me/features/wardrobe/domain/confirm_clothing_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/delete_clothing_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/send_clothing_photo_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/add_photo_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

class MockSendClothingPhotoUseCase extends Mock
    implements SendClothingPhotoUseCase {}

class MockConfirmClothingPhotoUseCase extends Mock
    implements ConfirmClothingPhotoUseCase {}

class MockDeleteClothingPhotoUseCase extends Mock
    implements DeleteClothingPhotoUseCase {}

class MockAppGlobalViewModel extends AutoDisposeNotifier<AppGlobalStateHolder>
    with Mock
    implements AppGlobalViewModel {}

void main() {
  late MockSendClothingPhotoUseCase mockSend;
  late MockConfirmClothingPhotoUseCase mockConfirm;
  late MockDeleteClothingPhotoUseCase mockDelete;
  late MockAppGlobalViewModel mockGlobal;
  late ProviderContainer container;

  setUp(() {
    mockSend = MockSendClothingPhotoUseCase();
    mockConfirm = MockConfirmClothingPhotoUseCase();
    mockDelete = MockDeleteClothingPhotoUseCase();
    mockGlobal = MockAppGlobalViewModel();

    container = ProviderContainer(
      overrides: [
        addPhotoViewModelProvider.overrideWith(
          () => AddPhotoViewModel.test(
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
    registerFallbackValue(ClothingCategoryEnum.ALL);
    addTearDown(container.dispose);
  });

  test('onImageFetched sets image and mode', () {
    final file = File('test.jpg');
    final notifier = container.read(addPhotoViewModelProvider.notifier);

    notifier.onImageFetched(file);

    final state = container.read(addPhotoViewModelProvider);
    expect(state.image, file);
    expect(state.addPhotoPageMode, AddPhotoPageMode.acceptPhoto);
  });

  test('sendClothingPhoto sets state on success', () async {
    final file = File('image.jpg');
    final response = SendClothingPhotoResponse(
      'abc123',
      ClothingCategoryEnum.BLAZER,
    );

    when(() => mockSend.call(file))
        .thenAnswer((_) async => Result.success(response));

    final notifier = container.read(addPhotoViewModelProvider.notifier);
    notifier.onImageFetched(file);
    await notifier.sendClothingPhoto(file);

    final state = container.read(addPhotoViewModelProvider);

    expect(state.isImageAddLoading, false);
    expect(state.addPhotoPageMode, AddPhotoPageMode.fillData);
    expect(state.clothingForm.selectedCategory, ClothingCategoryEnum.BLAZER);
    expect(state.clothingForm.isRecommendedCategory, true);
  });

  test('sendClothingPhoto handles ImageProcessFailure', () async {
    final file = File('image.jpg');
    final failure =
        ImageProcessFailure("", ImageErrorTypeEnum.NO_CLOTHING_DETECTED);

    when(() => mockSend.call(file))
        .thenAnswer((_) async => Result.fail(failure));

    final notifier = container.read(addPhotoViewModelProvider.notifier);
    await notifier.sendClothingPhoto(file);

    final state = container.read(addPhotoViewModelProvider);

    expect(state.isImageAddLoading, false);
    expect(state.imageProcessingError, ImageErrorTypeEnum.NO_CLOTHING_DETECTED);
  });

  test('sendClothingPhoto handles generic failure with showFailure', () async {
    final file = File('image.jpg');
    final failure = ServerFailure("Generic", 500);

    when(() => mockSend.call(file))
        .thenAnswer((_) async => Result.fail(failure));

    final notifier = container.read(addPhotoViewModelProvider.notifier);
    await notifier.sendClothingPhoto(file);

    verify(() => mockGlobal.showFailure(failure)).called(1);
    expect(container.read(addPhotoViewModelProvider).isImageAddLoading, false);
  });

  test('sendConfirmationData calls onSuccess on success', () async {
    const imageId = "abc123";
    when(() => mockSend.call(any())).thenAnswer((_) async => Result.success(
        SendClothingPhotoResponse(imageId, ClothingCategoryEnum.ALL)));
    when(() => mockConfirm.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success(null));

    final notifier = container.read(addPhotoViewModelProvider.notifier);
    await notifier.sendClothingPhoto(File('file.jpg'));

    var called = false;
    await notifier.sendConfirmationData(() {
      called = true;
    });

    expect(called, true);
    expect(container.read(addPhotoViewModelProvider).isImageAddLoading, false);
  });

  test('sendConfirmationData calls showFailure on failure', () async {
    when(() => mockConfirm.call(any(), any(), any()))
        .thenAnswer((_) async => Result.fail(ServerFailure('fail', 500)));

    final notifier = container.read(addPhotoViewModelProvider.notifier);
    await notifier.sendConfirmationData(() {});

    verify(() => mockGlobal.showFailure(any())).called(1);
  });

  test('onTextChanged updates clothing form', () {
    final notifier = container.read(addPhotoViewModelProvider.notifier);
    notifier.onTextChanged("Jacket");

    final state = container.read(addPhotoViewModelProvider);
    expect(state.clothingForm.nameText, "Jacket");
  });

  test('onCategorySelected updates form and disables recommendation', () {
    final notifier = container.read(addPhotoViewModelProvider.notifier);
    notifier.onCategorySelected(ClothingCategoryEnum.HOODIE);

    final state = container.read(addPhotoViewModelProvider);
    expect(state.clothingForm.selectedCategory, ClothingCategoryEnum.HOODIE);
    expect(state.clothingForm.isRecommendedCategory, false);
  });

  test('onBackAction clears state or pops', () async {
    final notifier = container.read(addPhotoViewModelProvider.notifier);
    notifier.onImageFetched(File('dummy.jpg'));

    notifier.onBackAction();

    final state = container.read(addPhotoViewModelProvider);
    expect(state.addPhotoPageMode, AddPhotoPageMode.pickPhoto);
    expect(state.image, null);
  });

  test('clearImageData calls deleteClothingPhotoUseCase if imageId exists',
      () async {
    const imageId = "abc123";
    when(() => mockSend.call(any())).thenAnswer((_) async => Result.success(
        SendClothingPhotoResponse(imageId, ClothingCategoryEnum.ALL)));
    when(() => mockDelete.call(imageId))
        .thenAnswer((_) async => Result.success(null));

    final notifier = container.read(addPhotoViewModelProvider.notifier);
    await notifier.sendClothingPhoto(File('dummy.jpg'));

    await notifier.clearImageData();
    verify(() => mockDelete.call(imageId)).called(1);
  });
}
