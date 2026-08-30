import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/time_extension.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:provider/provider.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsArticleModel article;

  const NewsDetailsScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkController>(
      builder: (context, controller, child) {
        final isBookmarked = controller.isBookmarked(article.url);

        final screenWidth = MediaQuery
            .of(context)
            .size
            .width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final imageHeight = isLandscape ? screenHeight * 0.65 : screenHeight * 0.35;
    final titleFontSize = isTablet ? 28.0 : 20.0;
    final sourceFontSize = isTablet ? 18.0 : 16.0;
    final timeFontSize = isTablet ? 16.0 : 14.0;
    final descriptionFontSize = isTablet ? 20.0 : 17.0;
    final avatarRadius = isTablet ? 24.0 : 15.0;
    final horizontalPadding = isTablet ? 24.0 : 16.0;
    final verticalPadding = isTablet ? 20.0 : 16.0;
    final appBarFontSize = isTablet ? 32.0 : 24.0;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'News Details',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(
                color: Colors.black,
                fontSize: appBarFontSize,
                letterSpacing: 3,
                fontFamily: 'times new roman',
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (isBookmarked) {
                    controller.removeBookmark(article.url);
                  } else {
                    controller.addBookmark(article);
                  }
                },
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked
                      ? Theme
                      .of(context)
                      .colorScheme
                      .primary
                      : null,
                ),
              ),
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
                borderRadius: BorderRadius.circular(16),
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
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                ),
              ),
              SizedBox(height: verticalPadding),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: titleFontSize,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
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
                  const SizedBox(width: 12),
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
                  const SizedBox(width: 12),
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
              const SizedBox(height: 20),
              Text(
                article.description ?? "No description available.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: descriptionFontSize,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.8,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
        );
      },
    );
  }
}
