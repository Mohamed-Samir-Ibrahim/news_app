import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/time_extension.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/features/layout/home/controller/home_controller.dart';
import 'package:news_app/features/layout/home/trending_news.dart';
import 'package:news_app/features/layout/home/view_all_screen.dart';
import 'package:provider/provider.dart';

import '../news_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final double horizontalPadding = screenWidth * 0.04; // 4% of width
    final double verticalSpacing = screenHeight * 0.02; // 2% of height
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
                          return _NewsCard(article: article);
                        }, childCount: homeController.topHeadlines.length),
                      ),
                    )
                    : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final article = homeController.topHeadlines[index];
                        return _NewsCard(article: article);
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
class _NewsCard extends StatelessWidget {
  final NewsArticleModel article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    // Responsive dimensions
    final double imageHeight =
        isTablet ? screenHeight * 0.15 : screenHeight * 0.12;
    final double imageWidth = isTablet ? screenWidth * 0.3 : screenWidth * 0.35;

    final double titleFontSize =
        isTablet ? screenWidth * 0.025 : screenWidth * 0.04;
    final double sourceFontSize = screenWidth * 0.03;

    final double borderRadius = screenWidth * 0.03;
    final double verticalPadding = screenHeight * 0.01;
    final double horizontalCardPadding = screenWidth * 0.04;
    final double gapBetweenImageAndText = screenWidth * 0.03;
    final double gapAfterTitle = screenHeight * 0.01;
    final double avatarRadius = screenWidth * 0.02;
    final double gapBetweenAvatarAndText = screenWidth * 0.015;
    final double bookmarkPaddingLeft = screenWidth * 0.02;
    final double bookmarkPaddingTop = screenHeight * 0.025;
    final double bookmarkIconSize =
        isTablet ? screenWidth * 0.04 : screenWidth * 0.055;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalCardPadding,
        vertical: verticalPadding,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailsScreen(article: article),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? "",
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[200]),
                errorWidget:
                    (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, size: screenWidth * 0.06),
                    ),
              ),
            ),
            SizedBox(width: gapBetweenImageAndText),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'times new roman',
                      height: 1.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: gapAfterTitle),
                  Row(
                    children: [
                      if (article.urlToImage != null)
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundImage: CachedNetworkImageProvider(
                            article.urlToImage!,
                          ),
                        ),
                      SizedBox(width: gapBetweenAvatarAndText),
                      Expanded(
                        child: Text(
                          "${article.sourceName} • ${article.publishedAt.formatTimeAgo()}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: sourceFontSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bookmark icon
            Padding(
              padding: EdgeInsets.only(
                left: bookmarkPaddingLeft,
                top: bookmarkPaddingTop,
              ),
              child: Icon(
                Icons.bookmark_border,
                color: Colors.black,
                size: bookmarkIconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
