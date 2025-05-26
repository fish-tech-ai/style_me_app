import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';
import 'package:style_me/features/home/data/models/recent_and_favorite_outfit_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';

class GetRecentAndFavoriteOutfitUseCase {
  final OutfitRepository _repository;
  final NetworkRequestUtil _networkRequestUtil;

  GetRecentAndFavoriteOutfitUseCase(this._repository, this._networkRequestUtil);

  Future<Result<RecentAndFavoriteOutfitResponse>> call() {
    return _networkRequestUtil.makeRepositoryRequest(() async {
      final Future<OutfitsResponse> favoritesFuture =
          _repository.getFavoriteOutfits();
      final Future<OutfitsResponse> recentFuture =
          _repository.getRecentOutfits();

      final results = await Future.wait([favoritesFuture, recentFuture]);

      final favorites = results[0].data;
      final recent = results[1].data;
      return RecentAndFavoriteOutfitResponse(favorites, recent);
    });
  }
}
