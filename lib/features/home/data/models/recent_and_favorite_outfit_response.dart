import 'package:style_me/features/home/data/models/outfit.dart';

class RecentAndFavoriteOutfitResponse {
  final List<Outfit> favorites;
  final List<Outfit> recent;

  RecentAndFavoriteOutfitResponse(this.favorites, this.recent);
}