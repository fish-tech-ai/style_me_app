import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photos_response.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';
import 'package:style_me/features/checkroom/domain/get_user_original_photos_use_case.dart';

class MockWardrobeRepository extends Mock implements WardrobeRepository {}

class MockNetworkRequestUtil extends Mock implements NetworkRequestUtil {}

void main() {
  late MockWardrobeRepository mockRepository;
  late MockNetworkRequestUtil mockNetworkUtil;
  late GetUserOriginalPhotosUseCase useCase;

  setUp(() {
    mockRepository = MockWardrobeRepository();
    mockNetworkUtil = MockNetworkRequestUtil();
    useCase = GetUserOriginalPhotosUseCase(mockRepository, mockNetworkUtil);
  });

  test('returns list of user photos with updated image URLs on success',
      () async {
    final userPhotos = [
      UserPhoto('1', 'initial_url', ""),
      UserPhoto('2', 'initial_url', ""),
    ];

    final response = UserPhotosResponse(userPhotos);

    when(() => mockRepository.getUserPhotos())
        .thenAnswer((_) async => response);
    when(() => mockRepository.getOriginalUserDataImage(any())).thenAnswer(
      (invocation) async {
        final id = invocation.positionalArguments.first;
        return OriginalImageUrlResponse("signed_url_$id");
      },
    );

    when(() => mockNetworkUtil.makeRepositoryRequest<List<UserPhoto>>(any()))
        .thenAnswer(
      (invocation) async {
        final futureFn = invocation.positionalArguments[0]
            as Future<List<UserPhoto>> Function();
        return Result.success(await futureFn());
      },
    );

    final result = await useCase();

    expect(result is ResultSuccess, true);
    result.collect((photos) {
      expect(photos.length, 2);
      expect(photos[0].image, 'signed_url_1');
      expect(photos[1].image, 'signed_url_2');
    }, (_) {});
  });

  test('returns failure when networkUtil fails', () async {
    final failure =
        Result<List<UserPhoto>>.fail(ServerFailure('network error', 500));

    when(() => mockNetworkUtil.makeRepositoryRequest<List<UserPhoto>>(any()))
        .thenAnswer((_) async => failure);

    final result = await useCase();
    expect(result is ResultFail, true);
  });
}
