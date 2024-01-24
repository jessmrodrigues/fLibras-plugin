import 'package:flutter/material.dart';
import 'package:test_singleton/flibras_view.dart';
import 'package:share/share.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'client/article.dart';
import 'client/news_repository.dart';

class News extends StatefulWidget {
  final NewsRepository newsRepository;

  const News({Key? key, required this.newsRepository}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  late List<Article> articles;
  late List<Article> favoriteArticles;
  late TextEditingController searchController;
  late TabController _tabController;

  late Dio dio;

  @override
  void initState() {
    super.initState();
    articles = [];
    favoriteArticles = [];
    searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);

    dio = Dio();

    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final newsResponse = await widget.newsRepository.getNews();
      setState(() {
        articles = newsResponse.articles;
      });
    } catch (e) {
      print('Error loading news: $e');
    }
  }

  Future<void> _searchNews(String query) async {
    try {
      if (query.isNotEmpty) {
        final newsResponse = await widget.newsRepository.getNameNews(query);
        setState(() {
          articles = newsResponse.articles;
        });
      } else {
        _loadNews();
      }
    } catch (e) {
      print('Error searching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Notícias'),
              Tab(text: 'Favoritos'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) {
                      _searchNews(query);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final isFavorite =
                        favoriteArticles.contains(articles[index]);
                    final imageUrl = articles[index].image_url;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(articles[index].title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(articles[index].description ?? ''),
                            SizedBox(height: 8.0),
                            if (imageUrl != null)
                              FutureBuilder<bool>(
                                future: _isImageUrlValid(imageUrl),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError ||
                                      !snapshot.data!) {
                                    // Exibe um widget de erro ou oculta a seção da imagem
                                    return Container(); // ou substitua por um widget de erro
                                  } else {
                                    // A URL é válida, exibe a imagem
                                    return Image.network(
                                      imageUrl,
                                      height: 100.0,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: isFavorite ? Colors.green : null,
                              ),
                              onPressed: () {
                                _addToFavorites(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                _shareNews(index);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FLibrasView(article: articles[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: favoriteArticles.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(favoriteArticles[index].title),
                        subtitle: Text(
                            favoriteArticles[index].description ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _removeFromFavorites(index);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FLibrasView(article: articles[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _isImageUrlValid(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _addToFavorites(int index) async {
    if (index >= 0 && index < articles.length) {
      final article = articles[index];

      if (!favoriteArticles.contains(article)) {
        setState(() {
          favoriteArticles.add(article);
        });

        _tabController.animateTo(1);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Esta notícia já está nos favoritos.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _removeFromFavorites(int index) {
    if (index >= 0 && index < favoriteArticles.length) {
      setState(() {
        favoriteArticles.removeAt(index);
      });
    }
  }

  Future<void> _shareNews(int index) async {
    if (index >= 0 && index < articles.length) {
      final article = articles[index];
      final textToShare = "${article.title}\n${article.link}";

      try {
        await Share.share(textToShare, subject: article.title);
      } catch (e) {
        print('Error sharing news: $e');
      }
    }
  }
}
