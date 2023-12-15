import 'dart:convert';

import 'package:dio/dio.dart';
import 'news_response.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://newsapi.org/v2';
  final String _apiKey = '8370674b5f1d4279971a32f357a42167';

  ApiService();

  Future<NewsResponse> fetchNews() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/top-headlines?sources=google-news-br&apiKey=8370674b5f1d4279971a32f357a42167',
      );

      if (response.statusCode == 200) {
        return NewsResponse.fromJson(response.data);
      } else {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<Map<String, dynamic>> getByNewsName(String query) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/everything?q=$query&apiKey=$_apiKey',
      );
      return json.decode(response.toString());
    } catch (error) {
      throw Exception('Failed to load $query news: $error');
    }
  }
}
