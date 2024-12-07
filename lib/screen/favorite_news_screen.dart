import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/data/database.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/screen/article_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({
    super.key,
  });
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteDataBase db = FavoriteDataBase();

  @override
  void initState() {
    db.loadData(); // Load the favorite news when the screen is initialized
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Text(
                  "Favorite",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' News',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favoriteList').listenable(),
        builder: (context, Box box, _) {
          // Get the favorite news list from Hive
          var favoriteArticles = db.favoriteList;
          return favoriteArticles.isEmpty
              ? const Center(child: Text("No favorites yet"))
              : ListView.builder(
                  itemCount: favoriteArticles.length,
                  itemBuilder: (context, index) {
                    var article = favoriteArticles[index];
                    return ShowCategory(
                        imgUrl: article.urlToImage ?? '',
                        url: article.url ?? '',
                        descriptionNews: article.description ?? '',
                        title: article.title ?? '',
                        onDelete: () {
                          setState(() {
                            favoriteArticles.removeAt(index);
                            db.updateDatabase();
                          });
                        });
                  },
                );
        },
      ),
    );
  }
}

extension on List<ArticleModel> {
  void update() {}
}

class ShowCategory extends StatelessWidget {
  String imgUrl, title, descriptionNews, url;
  final VoidCallback onDelete;

  ShowCategory(
      {super.key,
      required this.imgUrl,
      required this.descriptionNews,
      required this.title,
      required this.url,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url))),
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: imgUrl,
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Stack(
                              alignment: Alignment.center, // Center the loader
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  color: Colors.grey[
                                      200], // Optional placeholder background color
                                ),
                                const SizedBox(
                                  width: 30, // Smaller size for the loader
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                    strokeWidth: 5, // Adjust thickness
                                  ),
                                ),
                              ],
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                                onPressed: onDelete,
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                  size: 30,
                                )),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    descriptionNews,
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
