import 'package:flutter/material.dart';
import 'package:news_app/features/layout/home/controller/home_controller.dart';
import 'package:news_app/features/layout/home/trending_news.dart';
import 'package:news_app/features/layout/home/view_all_screen.dart';
import 'package:news_app/shared/news_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalSpacing = screenHeight * 0.02;
    final double categoryListHeight = screenHeight * (isTablet ? 0.07 : 0.06);
    final double categoryFontSize =
        isTablet ? screenWidth * 0.028 : screenWidth * 0.045;
    final double categoryItemSpacing = screenWidth * 0.04;

    return Consumer<HomeController>(
      builder: (context, homeController, child) {
        return RefreshIndicator(
          onRefresh: () => homeController.refreshNews(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: TrendingNews(
                  allTopNews: homeController.everythingArticles,
                  isLoading: homeController.isLoadingHeadlines,
                  topNews:
                      homeController.everythingArticles.length > 3
                          ? homeController.everythingArticles
                              .getRange(0, 4)
                              .toList()
                          : [],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalSpacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              letterSpacing: 1,
                              fontSize:
                                  isTablet
                                      ? screenWidth * 0.04
                                      : screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ViewAllScreen(
                                        topNews: homeController.topHeadlines,
                                      ),
                                ),
                              );
                            },
                            child: Text(
                              'View all',
                              style: TextStyle(
                                fontSize:
                                    isTablet
                                        ? screenWidth * 0.035
                                        : screenWidth * 0.04,
                                decoration: TextDecoration.underline,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: verticalSpacing),
                      SizedBox(
                        height: categoryListHeight,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final category = homeController.categories[index];
                            final isSelected =
                                homeController.selectedCategory == category;
                            return GestureDetector(
                              onTap:
                                  () => homeController.changeCategory(category),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: categoryFontSize,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      fontFamily: 'times new roman',
                                      color:
                                          isSelected ? Colors.red : Colors.grey,
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: screenHeight * 0.005,
                                      ),
                                      height: screenHeight * 0.002,
                                      width: screenWidth * 0.1,
                                      color: Colors.red,
                                    ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder:
                              (_, __) => SizedBox(width: categoryItemSpacing),
                          itemCount: homeController.categories.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (homeController.isLoadingEverything)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (homeController.topHeadlines.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No news articles found\nPull down to refresh',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ),
                )
              else
                isTablet
                    ? SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: verticalSpacing,
                          crossAxisSpacing: horizontalPadding,
                          childAspectRatio: 0.85,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final article = homeController.topHeadlines[index];
                          return NewsCard(article: article);
                        }, childCount: homeController.topHeadlines.length),
                      ),
                    )
                    : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final article = homeController.topHeadlines[index];
                        return NewsCard(article: article);
                      }, childCount: homeController.topHeadlines.length),
                    ),
            ],
          ),
        );
      },
    );
  }
}

// ─── News Card ──────────────────────────────────────────────────────────────
