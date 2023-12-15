import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
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
  late TextEditingController searchController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    articles = [];
    searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
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
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(articles[index].title ?? ''),
                        subtitle: Text(articles[index].description ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.star),
                          onPressed: () {
                            // adicionar logica para favoritas
                          },
                        ),
                        onTap: () {
                          _launchURL(articles[index].url); // mudar para pegar o content dps
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const Center(
            child: Text('Tela de Favoritos'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String? url) async {
    if (url != null) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
