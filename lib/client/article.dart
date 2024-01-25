class Article {
  final String author;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? content;
  final String? link;
  final String? pubdate;

  Article(
      {required this.author,
      required this.title,
      this.description,
      this.imageUrl,
      this.content,
      this.link,
      this.pubdate});

  factory Article.fromJson(Map<String, dynamic> json) {
    final author = json['creator'] != null
        ? json['creator'].join(', ')
        : 'Autor Desconhecido';

    return Article(
      pubdate: json['pubDate'],
      author: author,
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      content: json['content'],
      link: json['link'],
    );
  }
}
