import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/models/news_article_model.dart';
import '../../core/services/preference_manager.dart';

class BookmarkController extends ChangeNotifier {
  Box<NewsArticleModel>? bookmarksBox;
  List<NewsArticleModel> bookmarks = [];
  String? userId;

  Future<void> init() async {
    userId = PreferencesManager().getString('userId');
    if (userId == null) return;

    bookmarksBox = await Hive.openBox<NewsArticleModel>('bookmarks_$userId');
    bookmarks = bookmarksBox!.values.toList();
    notifyListeners();
  }

  Future<void> addBookmark(NewsArticleModel article) async {
    if (bookmarksBox == null) return;

    final exists = bookmarksBox!.values.any((a) => a.url == article.url);
    if (!exists) {
      await bookmarksBox!.add(article);
      bookmarks = bookmarksBox!.values.toList();
      notifyListeners();
    }
  }

  Future<void> removeBookmark(String url) async {
    if (bookmarksBox == null) return;

    final key = bookmarksBox!.keys.firstWhere(
      (k) => bookmarksBox!.get(k)?.url == url,
      orElse: () => null,
    );

    if (key != null) {
      await bookmarksBox!.delete(key);
      bookmarks = bookmarksBox!.values.toList();
      notifyListeners();
    }
  }

  bool isBookmarked(String url) {
    if (bookmarksBox == null || !bookmarksBox!.isOpen) return false;
    return bookmarksBox!.values.any((a) => a.url == url);
  }
}
