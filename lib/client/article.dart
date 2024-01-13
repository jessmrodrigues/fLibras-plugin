class Article {
  final String? author;
  final String title;
  final String? description;
  final String? image_url;
  final String? content;
  final String? link;

  Article(
      {this.author,
      required this.title,
      this.description,
      this.image_url,
      this.content,
      this.link});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      image_url: json['image_url'],
      content: json['content'],
      link: json['link'],
    );
  }
}
