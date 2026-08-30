import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/core/services/preference_manager.dart';

class BookmarkController extends ChangeNotifier {
  Box<NewsArticleModel>? _bookmarksBox;
  String? _userId;

  Future<void> init() async {
    _userId = PreferencesManager().getString('userId') ?? 'default_user';
    final boxName = 'bookmarks_$_userId';
    if (!Hive.isBoxOpen(boxName)) {
      _bookmarksBox = await Hive.openBox<NewsArticleModel>(boxName);
    } else {
      _bookmarksBox = Hive.box<NewsArticleModel>(boxName);
    }
    notifyListeners();
  }

  bool isBookmarked(String url) {
    if (_bookmarksBox == null) return false;
    return _bookmarksBox!.values.any((article) => article.url == url);
  }

  Future<void> addBookmark(NewsArticleModel article) async {
    if (_bookmarksBox == null) await init();
    await _bookmarksBox!.put(article.url, article);
    notifyListeners();
  }

  Future<void> removeBookmark(String url) async {
    if (_bookmarksBox == null) await init();
    await _bookmarksBox!.delete(url);
    notifyListeners();
  }

  List<NewsArticleModel> get bookmarks {
    if (_bookmarksBox == null) return [];
    return _bookmarksBox!.values.toList();
  }
}
