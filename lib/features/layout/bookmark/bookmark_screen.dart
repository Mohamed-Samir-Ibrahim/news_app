import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/time_extension.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:news_app/features/layout/news_details_screen.dart';
import 'package:provider/provider.dart';

class BookMarkScreen extends StatelessWidget {
  const BookMarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.015;
    final double appBarTitleFontSize =
        isTablet ? screenWidth * 0.04 : screenWidth * 0.055;

    // Empty state dimensions
    final double emptyIconSize = screenWidth * 0.2; // ~80 on phone
    final double emptyTextFontSize = screenWidth * 0.045; // ~18
    final double emptyGap = screenHeight * 0.02; // ~16

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bookmarks',
          style: TextStyle(
            color: Colors.black,
            fontSize: appBarTitleFontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'times new roman',
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<BookmarkController>(
        builder: (context, bookmarkController, child) {
          if (bookmarkController.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: emptyIconSize,
                    color: Colors.grey,
                  ),
                  SizedBox(height: emptyGap),
                  Text(
                    'No bookmarks yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: emptyTextFontSize,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            itemCount: bookmarkController.bookmarks.length,
            separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.02),
            itemBuilder: (_, index) {
              final article = bookmarkController.bookmarks[index];
              return _BookmarkCard(article: article);
            },
          );
        },
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final NewsArticleModel article;

  const _BookmarkCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final double imageHeight =
        isTablet ? screenHeight * 0.15 : screenHeight * 0.12;
    final double imageWidth = isTablet ? screenWidth * 0.3 : screenWidth * 0.35;
    final double titleFontSize =
        isTablet ? screenWidth * 0.025 : screenWidth * 0.04;
    final double sourceFontSize = screenWidth * 0.03;
    final double borderRadius = screenWidth * 0.03;
    final double gapBetweenImageAndText = screenWidth * 0.03;
    final double gapAfterTitle = screenHeight * 0.01;
    final double avatarRadius = screenWidth * 0.02;
    final double gapBetweenAvatarAndText = screenWidth * 0.015;
    final double bookmarkIconSize =
        isTablet ? screenWidth * 0.04 : screenWidth * 0.055;
    final double errorIconSize = screenWidth * 0.06;

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        child: Icon(Icons.broken_image, size: errorIconSize),
                      ),
                ),
              ),
              SizedBox(width: gapBetweenImageAndText),
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
              SizedBox(
                width: bookmarkIconSize * 1.6, // sufficient tap area
                height: bookmarkIconSize * 1.6,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed:
                      () => bookmarkController.removeBookmark(article.url),
                  icon: Icon(
                    Icons.bookmark,
                    color: Colors.red,
                    size: bookmarkIconSize,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
