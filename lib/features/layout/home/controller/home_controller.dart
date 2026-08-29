import 'package:flutter/material.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/core/repo/base_news_articles_repository.dart';
import 'package:news_app/core/services/service_locator.dart';

class HomeController extends ChangeNotifier {
  final List<String> categories = [
    'Top News',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  final BaseNewsArticlesRepositry _repository =
      locator<BaseNewsArticlesRepositry>();
  List<NewsArticleModel> topHeadlines = [];
  List<NewsArticleModel> everythingArticles = [];
  bool isLoadingHeadlines = true;
  bool isLoadingEverything = true;
  String selectedCategory = 'Top News';

  void init() {
    loadNews();
  }

  Future<void> loadNews() async {
    // Reset loading states
    isLoadingHeadlines = true;
    isLoadingEverything = true;
    notifyListeners();

    try {
      print('Loading news for category: $selectedCategory');

      // Fetch headlines based on selected category
      final headlines = await _repository.fetchHeadlines(
        category:
            selectedCategory == 'Top News'
                ? 'general'
                : selectedCategory.toLowerCase(),
      );
      print('Headlines received: ${headlines.length}');
      topHeadlines = headlines;
      isLoadingHeadlines = false;
      notifyListeners(); // Notify after headlines update
    } catch (e) {
      print('Error loading headlines: $e');
      isLoadingHeadlines = false;
      topHeadlines = [];
      notifyListeners();
    }

    try {
      // Fetch everything articles (trending/news)
      final everything = await _repository.fetchEverything(
        query:
            selectedCategory == 'Top News' ? 'latest news' : selectedCategory,
      );
      print('Everything articles received: ${everything.length}');
      everythingArticles = everything;
      isLoadingEverything = false;
      notifyListeners(); // Notify after everything update
    } catch (e) {
      print('Error loading everything articles: $e');
      isLoadingEverything = false;
      everythingArticles = [];
      notifyListeners();
    }
  }

  void changeCategory(String category) {
    if (selectedCategory == category) return; // Don't reload if same category

    selectedCategory = category;
    notifyListeners();
    loadNews(); // Reload news for new category
  }

  // Add refresh method for pull-to-refresh functionality
  Future<void> refreshNews() async {
    await loadNews();
  }
}
