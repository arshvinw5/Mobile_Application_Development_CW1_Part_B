import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class News {
  String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
  //this list to store news from article model object
  List<ArticleModel> news = [];

  Future<void> fetchNews() async {
    String url =
        "https://newsapi.org/v2/everything?q=apple&from=2024-12-03&to=2024-12-03&sortBy=popularity&apiKey=$apiKey";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      //if the status is okay in api json then it's calling articles
      jsonData['articles'].forEach((element) {
        //if url to img is not null and description is not null then it pass the values to save in the list
        if (element['urlToImage'] != null && element['description'] != null) {
          //just made a object then assign the data from api to variables in the class then that object from the class has been stored in news list
          ArticleModel articleModel = ArticleModel(
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              author: element["author"],
              content: element["content"],
              publishedAt: element["publishedAt"]);
          news.add(articleModel);
        }
      });
    }
  }
}
