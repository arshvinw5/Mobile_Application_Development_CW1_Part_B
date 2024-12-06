// import 'package:news_app/models/slider_model.dart';

// //list function
// List<SliderModel> getSlider() {
//   List<SliderModel> slider = [];
//   //making new instance
//   SliderModel categoryModel = new SliderModel();

//   categoryModel.name = "Business";
//   categoryModel.image = "assets/imgs/Business.jpg";
//   slider.add(categoryModel);
//   categoryModel = new SliderModel();

//   categoryModel.name = "General";
//   categoryModel.image = "assets/imgs/General.jpg";
//   slider.add(categoryModel);
//   categoryModel = new SliderModel();

//   categoryModel.name = "Health";
//   categoryModel.image = "assets/imgs/Health.jpg";
//   slider.add(categoryModel);
//   categoryModel = new SliderModel();

//   categoryModel.name = "Music";
//   categoryModel.image = "assets/imgs/Music.jpg";
//   slider.add(categoryModel);
//   categoryModel = new SliderModel();

//   categoryModel.name = "Science";
//   categoryModel.image = "assets/imgs/Science.jpg";
//   slider.add(categoryModel);
//   categoryModel = new SliderModel();

//   categoryModel.name = "Sport";
//   categoryModel.image = "assets/imgs/Sport.jpg";
//   slider.add(categoryModel);

//   return slider;
// }

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/slider_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BreakingNews {
  String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
  //this list to store news from article model object
  List<SliderModel> breakingNews = [];

  Future<void> fetchBreakingNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$apiKey";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      //if the status is okay in api json then it's calling articles
      jsonData['articles'].forEach((element) {
        //if url to img is not null and description is not null then it pass the values to save in the list
        if (element['urlToImage'] != null && element['description'] != null) {
          //just made a object then assign the data from api to variables in the class then that object from the class has been stored in news list
          SliderModel sliderModel = SliderModel(
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              author: element["author"],
              content: element["content"],
              publishedAt: element["publishedAt"]);
          breakingNews.add(sliderModel);
        }
      });
    }
  }
}




//
