class Article {
  final String? author;
  final String title;
  final String? description;
  final String? urlToImage;
  final String? content;
  final String? link;

  Article({
    this.author,
    required this.title,
    this.description,
    this.urlToImage,
    this.content,
    this.link
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      content: json['content'],
      link: json['link'],
    );
  }
}
