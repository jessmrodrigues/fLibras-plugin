import 'dart:convert';

import 'package:dio/dio.dart';
import 'news_response.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://newsdata.io/api/1/news';
  final String _apiKey = 'pub_35028edaa643686e9a6d35c9666ff6a0ac1fc';
  final String _language = 'pt';

  ApiService();

  Future<NewsResponse> fetchNews() async {
    try {
      final response = await _dio.get(
        '$_baseUrl?apiKey=$_apiKey&language=$_language',
      );

      if (response.statusCode == 200) {
        return NewsResponse.fromJson(response.data);
      } else {
        throw Exception('Request error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<NewsResponse> getByNewsName(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl?apiKey=$_apiKey&qInTitle=$query&language=$_language',
      );

      if (response.statusCode == 200) {
        return NewsResponse.fromJson(response.data);
      } else {
        throw Exception('Request error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}
