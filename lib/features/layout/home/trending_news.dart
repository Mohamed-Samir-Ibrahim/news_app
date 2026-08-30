import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/time_extension.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:news_app/features/layout/home/trending_screen.dart';
import 'package:news_app/features/layout/news_details_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/models/news_article_model.dart';

class TrendingNews extends StatelessWidget {
  final List<NewsArticleModel> topNews;
  final bool isLoading;
  final List<NewsArticleModel> allTopNews;

  const TrendingNews({
    super.key,
    required this.isLoading,
    required this.topNews,
    required this.allTopNews,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final double containerHeight =
        isTablet ? screenHeight * 0.55 : screenHeight * 0.50;

    final double backgroundHeight =
        isTablet ? screenHeight * 0.45 : screenHeight * 0.38;

    final double logoFontSize =
        isTablet ? screenWidth * 0.045 : screenWidth * 0.07;
    final double trendingTitleFontSize =
        isTablet ? screenWidth * 0.028 : screenWidth * 0.05;
    final double viewAllFontSize =
        isTablet ? screenWidth * 0.02 : screenWidth * 0.035;

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalGap = screenHeight * 0.025;
    final double gapBetweenItems = screenWidth * 0.04;

    final double cardWidth = isTablet ? screenWidth * 0.5 : screenWidth * 0.7;
    final double cardBorderRadius = screenWidth * 0.04;

    return SizedBox(
      height: containerHeight,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/trending_news_background.png',
            fit: BoxFit.cover,
            height: backgroundHeight,
            width: double.infinity,
          ),
          Container(
            height: backgroundHeight,
            color: Colors.black.withValues(alpha: 0.4),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'NEWST',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'times new roman',
                      fontSize: logoFontSize,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                SizedBox(height: verticalGap),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending News',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: trendingTitleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      TrendingScreen(topNews: allTopNews),
                            ),
                          );
                        },
                        child: Text(
                          'View all',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: viewAllFontSize,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: verticalGap * 0.6),
                Expanded(
                  child:
                      isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: topNews.length,
                            separatorBuilder:
                                (_, __) => SizedBox(width: gapBetweenItems),
                            itemBuilder: (context, index) {
                              final article = topNews[index];
                              return _TrendingCard(
                                article: article,
                                cardWidth: cardWidth,
                                borderRadius: cardBorderRadius,
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final NewsArticleModel article;
  final double cardWidth;
  final double borderRadius;

  const _TrendingCard({
    required this.article,
    required this.cardWidth,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final double titleFontSize =
        isTablet ? screenWidth * 0.025 : screenWidth * 0.04;
    final double sourceFontSize = screenWidth * 0.03;
    final double avatarRadius = screenWidth * 0.025;

    final double textPadding = screenWidth * 0.04;
    final double gapAfterTitle = screenHeight * 0.01;
    final double gapBetweenAvatarAndText = screenWidth * 0.02;

    return Consumer<BookmarkController>(
      builder: (context, bookmarkController, child) {
        final isBookmarked = bookmarkController.isBookmarked(article.url);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => NewsDetailsScreen(
                      article: article,
                      isBookmarked: isBookmarked,
                      onBookmarkToggle: () {
                        if (isBookmarked) {
                          bookmarkController.removeBookmark(article.url);
                        } else {
                          bookmarkController.addBookmark(article);
                        }
                      },
                    ),
              ),
            );
          },
          child: SizedBox(
            width: cardWidth,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage ?? '',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[300]),
                    errorWidget:
                        (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.broken_image,
                            size: screenWidth * 0.06,
                          ),
                        ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.02,
                  left: textPadding,
                  right: textPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                        maxLines: 2,
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
                                color: Colors.white70,
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (isBookmarked) {
                        bookmarkController.removeBookmark(article.url);
                      } else {
                        bookmarkController.addBookmark(article);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
