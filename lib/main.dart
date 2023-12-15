import 'package:flutter/material.dart';
import 'client/api_service.dart';
import 'client/news_repository.dart';
import 'news.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCC - fLibras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return News(newsRepository: snapshot.data as NewsRepository);
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<NewsRepository> _initializeApp() async {
    try {
      final apiService = ApiService();
      final newsRepository = NewsRepository(apiService);
      return newsRepository;
    } catch (e) {
      rethrow;
    }
  }
}
