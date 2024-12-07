class FavoriteModel {
  String? title, description, url, urlToImage, author, content, publishedAt;
  bool isFavorite; // Add this property

  FavoriteModel({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.author,
    required this.content,
    required this.publishedAt,
    this.isFavorite = false, // Default value is false
  });
}
