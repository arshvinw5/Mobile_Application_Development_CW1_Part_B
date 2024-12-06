// class SliderModel {
//   String? image;
//   String? name;
// }

class SliderModel {
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? content;
  String? publishedAt;

  //contractor
  SliderModel(
      {this.author,
      this.description,
      this.title,
      this.url,
      this.urlToImage,
      this.content,
      this.publishedAt});
}
