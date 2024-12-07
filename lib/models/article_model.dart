class ArticleModel {
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? content;
  String? publishedAt;

  // Constructor
  ArticleModel({
    this.author,
    this.description,
    this.title,
    this.url,
    this.urlToImage,
    this.content,
    this.publishedAt,
  });

  // Convert a map to an ArticleModel
  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      author: map['author'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      content: map['content'],
      publishedAt: map['publishedAt'],
    );
  }

  // Convert an ArticleModel to a map
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'content': content,
      'publishedAt': publishedAt,
    };
  }
}
