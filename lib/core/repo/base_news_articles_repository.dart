import 'package:news_app/core/models/news_article_model.dart';

abstract class BaseNewsArticlesRepositry {
  Future<List<NewsArticleModel>> fetchHeadlines({String category = 'general'});

  Future<List<NewsArticleModel>> fetchEverything({required String query});
}
