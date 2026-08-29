import 'package:get_it/get_it.dart';
import 'package:news_app/core/repo/base_news_articles_repository.dart';
import 'package:news_app/core/repo/news_articles_repository.dart';
import 'package:news_app/features/layout/home/api/api_services.dart';
import 'package:news_app/features/layout/home/api/base_api_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<BaseApiService>(ApiService());

  locator.registerSingleton<BaseNewsArticlesRepositry>(
    NewsArticlesRepositry(locator<BaseApiService>()),
  );
}
