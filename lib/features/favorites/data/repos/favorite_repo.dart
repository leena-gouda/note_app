


abstract class FavoriteRepo {


  Future<void> updateFavorite({
    required String noteId,
    required bool isFavorite,
    required bool isHidden,
  });

}