import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/core/repo/base_news_articles_repository.dart';
import 'package:news_app/features/layout/home/api/api_constants.dart';
import 'package:news_app/features/layout/home/api/base_api_service.dart';

class NewsArticlesRepositry extends BaseNewsArticlesRepositry {
  final BaseApiService _apiService;

  NewsArticlesRepositry(this._apiService);

  @override
  Future<List<NewsArticleModel>> fetchEverything({
    required String query,
  }) async {
    final url =
        '${ApiConstants.topHeadlinesEndPoint}?q=$query&sortBy=publishedAt&apiKey=${ApiConstants.apiKey}';
    final data = await _apiService.get(url);
    return (data['articles'] as List)
        .map((article) => NewsArticleModel.fromJson(article))
        .toList();
  }

  @override
  Future<List<NewsArticleModel>> fetchHeadlines({
    String category = 'general',
  }) async {
    final url =
        '${ApiConstants.topHeadlinesEndPoint}?country=us&category=$category&apiKey=${ApiConstants.apiKey}';
    final data = await _apiService.get(url);
    return (data['articles'] as List)
        .map((article) => NewsArticleModel.fromJson(article))
        .toList();
  }
}
