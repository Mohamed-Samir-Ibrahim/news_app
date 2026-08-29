import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/time_extension.dart';
import 'package:news_app/core/models/news_article_model.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsArticleModel article;
  final bool isBookmarked;
  final Function()? onBookmarkToggle;

  const NewsDetailsScreen({
    super.key,
    required this.article,
    required this.isBookmarked,
    this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final double imageHeight =
        isLandscape ? screenHeight * 0.65 : screenHeight * 0.35;

    final double appBarFontSize =
        isTablet ? screenWidth * 0.04 : screenWidth * 0.06;
    final double titleFontSize =
        isTablet ? screenWidth * 0.035 : screenWidth * 0.05;
    final double sourceFontSize =
        isTablet ? screenWidth * 0.025 : screenWidth * 0.04;
    final double timeFontSize =
        isTablet ? screenWidth * 0.02 : screenWidth * 0.035;
    final double descriptionFontSize =
        isTablet ? screenWidth * 0.028 : screenWidth * 0.045;
    final double avatarRadius =
        isTablet ? screenWidth * 0.03 : screenWidth * 0.04;

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.02;

    final double iconSize = screenWidth * 0.06;
    final double errorIconSize = screenWidth * 0.12;

    final double gapAfterImage = verticalPadding;
    final double gapAfterTitle = screenHeight * 0.015;
    final double gapAfterSourceRow = screenHeight * 0.025;
    final double gapAfterDescription = screenHeight * 0.05;
    final double gapBetweenAvatarAndText = screenWidth * 0.03;
    final double gapBetweenTextAndTime = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Details',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.black,
            fontSize: appBarFontSize,
            letterSpacing: 3,
            fontFamily: 'times new roman',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: iconSize),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.red : Colors.black,
              size: iconSize,
            ),
            onPressed: onBookmarkToggle,
          ),
          SizedBox(width: screenWidth * 0.02),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: verticalPadding),
              ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? '',
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  placeholder:
                      (_, __) => Container(
                        width: double.infinity,
                        height: imageHeight,
                        color: Colors.grey.shade300,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (_, __, ___) => Container(
                        width: double.infinity,
                        height: imageHeight,
                        color: Colors.grey.shade300,
                        child: Icon(Icons.broken_image, size: errorIconSize),
                      ),
                ),
              ),
              SizedBox(height: gapAfterImage),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: titleFontSize,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
              ),
              SizedBox(height: gapAfterTitle),
              Row(
                children: [
                  if (article.urlToImage != null &&
                      article.urlToImage!.isNotEmpty)
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: CachedNetworkImageProvider(
                        article.urlToImage!,
                      ),
                    ),
                  SizedBox(width: gapBetweenAvatarAndText),
                  Expanded(
                    child: Text(
                      article.sourceName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: sourceFontSize,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: gapBetweenTextAndTime),
                  Text(
                    article.publishedAt.formatTimeAgo(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: timeFontSize,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: gapAfterSourceRow),
              Text(
                article.description ?? "No description available.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: descriptionFontSize,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.8,
                  height: 1.5,
                ),
              ),
              SizedBox(height: gapAfterDescription),
            ],
          ),
        ),
      ),
    );
  }
}
