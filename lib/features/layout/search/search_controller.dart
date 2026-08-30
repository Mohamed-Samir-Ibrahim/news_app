import 'package:flutter/material.dart';

import '../../../core/models/news_article_model.dart';
import '../../../core/repo/base_news_articles_repository.dart';
import '../../../core/services/service_locator.dart';

class SearchController1 extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  List<NewsArticleModel> res = [];
  bool isLoading = false;

  var error = null;

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      res = [];
      error = null;
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final repository = locator<BaseNewsArticlesRepositry>();
      final results = await repository.fetchEverything(query: query);
      res = results;
    } catch (e) {
      error = 'Error getting the results: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
