import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:provider/provider.dart';

class FavoriteProvider with ChangeNotifier {
  final List<ArticleModel> _favorites = [];

  List<ArticleModel> get favorites => _favorites;

  void toggleFavorite(ArticleModel article) {
    if (_favorites.contains(article)) {
      _favorites.remove(article);
    } else {
      _favorites.add(article);
    }
    notifyListeners();
  }

  bool isFavorite(ArticleModel article) {
    return _favorites.contains(article);
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
