import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/time_extension.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:news_app/features/layout/news_details_screen.dart';
import 'package:provider/provider.dart';

class TrendingScreen extends StatelessWidget {
  final List<NewsArticleModel>? topNews;

  const TrendingScreen({super.key, this.topNews});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final double horizontalPadding = screenWidth * 0.04; // 4% of width
    final double verticalPadding = screenHeight * 0.02; // 2% of height
    final double appBarHeight = screenHeight * (isTablet ? 0.08 : 0.07);
    final double titleFontSize =
        isTablet ? screenWidth * 0.04 : screenWidth * 0.06;

    final double gridSpacing = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text(
          'Trending News',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.black,
            fontSize: titleFontSize,
            letterSpacing: 2,
            fontFamily: 'times new roman',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:
          topNews == null || topNews!.isEmpty
              ? const Center(child: Text('No trending news available'))
              : isTablet || isLandscape
              ? GridView.builder(
                padding: EdgeInsets.all(horizontalPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLandscape && screenWidth > 900 ? 3 : 2,
                  crossAxisSpacing: gridSpacing,
                  mainAxisSpacing: gridSpacing,
                  childAspectRatio: 0.8,
                ),
                itemCount: topNews!.length,
                itemBuilder:
                    (context, index) => _TrendingCard(article: topNews![index]),
              )
              : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                itemCount: topNews!.length,
                itemBuilder:
                    (context, index) => _TrendingCard(article: topNews![index]),
              ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final NewsArticleModel article;

  const _TrendingCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final double imageHeight =
        isTablet || isLandscape ? screenHeight * 0.22 : screenHeight * 0.28;

    final double titleFontSize =
        isTablet ? screenWidth * 0.025 : screenWidth * 0.045;
    final double sourceFontSize = screenWidth * 0.032;
    final double timeFontSize = screenWidth * 0.03;

    final double cardMarginBottom =
        isTablet || isLandscape ? 0 : screenHeight * 0.025;
    final double cardPadding = screenWidth * 0.03;
    final double avatarRadius = screenWidth * 0.035;
    final double borderRadius = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.06;

    final double shadowSpreadRadius = screenWidth * 0.005;
    final double shadowBlurRadius = screenWidth * 0.025;
    final double shadowOffsetDy = screenHeight * 0.005;

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
          child: Container(
            margin: EdgeInsets.only(bottom: cardMarginBottom),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: shadowSpreadRadius,
                  blurRadius: shadowBlurRadius,
                  offset: Offset(0, shadowOffsetDy),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: article.urlToImage ?? '',
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) => Container(
                              height: imageHeight,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (_, __, ___) => Container(
                              height: imageHeight,
                              color: Colors.grey[200],
                              child: Icon(Icons.broken_image, size: iconSize),
                            ),
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
                            color: Colors.white.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked ? Colors.red : Colors.black,
                            size: iconSize * 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundImage:
                                  article.urlToImage != null
                                      ? CachedNetworkImageProvider(
                                        article.urlToImage!,
                                      )
                                      : null,
                              child:
                                  article.urlToImage == null
                                      ? Icon(
                                        Icons.person,
                                        size: avatarRadius * 0.8,
                                      )
                                      : null,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                article.sourceName,
                                style: TextStyle(
                                  fontSize: sourceFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              article.publishedAt.formatTimeAgo(),
                              style: TextStyle(
                                fontSize: timeFontSize,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
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
