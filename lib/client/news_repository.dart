import 'api_service.dart';
import 'news_response.dart';

class NewsRepository {
  final ApiService _apiService;

  NewsRepository(this._apiService);

  Future<NewsResponse> getNews() async {
    try {
      final newsResponse = await _apiService.fetchNews();
      return newsResponse;
    } catch (e) {
      throw Exception('Error getting news:: $e');
    }
  }

  Future<NewsResponse> getNameNews(String query) async {
    try {
      final newsResponse = await _apiService.getByNewsName(query);
      return newsResponse;
    } catch (e) {
      throw Exception('Error getting news: $e');
    }
  }
}
