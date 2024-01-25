import 'package:dio/dio.dart';
import 'news_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String _apiKey = dotenv.env['API_KEY'] ?? '';
  final String _language = dotenv.env['LANGUAGE'] ?? '';

  ApiService();

  Future<NewsResponse> fetchNews() async {
    try {
      final response = await _dio.get(
        '$_baseUrl?apiKey=$_apiKey&language=$_language',
      );

      return (response.statusCode == 200)
          ? NewsResponse.fromJson(response.data)
          : throw Exception('Request error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<NewsResponse> getByNewsName(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl?apiKey=$_apiKey&qInTitle=$query&language=$_language',
      );

      return (response.statusCode == 200)
          ? NewsResponse.fromJson(response.data)
          : throw Exception('Request error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
