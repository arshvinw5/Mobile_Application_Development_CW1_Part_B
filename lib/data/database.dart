// import 'package:hive/hive.dart';

// class ToDoDataBase {
//   List favoriteList = [];
//   //reference the box
//   final _myBox = Hive.box('favoriteList');

//   //load the data from Database
//   void loadData() {
//     favoriteList = _myBox.get('index');
//   }

//   //update Database
//   void updateDatabase() {
//     _myBox.put('index', favoriteList);
//   }
// }

import 'package:hive/hive.dart';
import 'package:news_app/models/article_model.dart'; // Make sure to import your article model

class FavoriteDataBase {
  List<ArticleModel> favoriteList = [];
  final _myBox = Hive.box('favoriteList');

  // Load data from Hive database
  void loadData() {
    var storedData = _myBox.get('index');
    if (storedData != null) {
      favoriteList = List<ArticleModel>.from(
          storedData.map((e) => ArticleModel.fromMap(e)));
    }
  }

  // Update the database with the new favorite list
  void updateDatabase() {
    _myBox.put('index', favoriteList.map((e) => e.toMap()).toList());
  }

  // Add a favorite article
  void addFavorite(ArticleModel article) {
    if (!favoriteList.contains(article)) {
      favoriteList.add(article);
      updateDatabase();
    }
  }

  // Remove a favorite article
  void removeFavorite(ArticleModel article) {
    favoriteList.remove(article);
    updateDatabase();
  }

  void updateData() {}
}
