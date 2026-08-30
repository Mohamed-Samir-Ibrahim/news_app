import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/time_extension.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:news_app/features/layout/home/controller/home_controller.dart';
import 'package:news_app/features/layout/news_details_screen.dart';
import 'package:provider/provider.dart';

class ViewAllScreen extends StatelessWidget {
  const ViewAllScreen({super.key, required List<NewsArticleModel> topNews});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.015;
    final double appBarLeadingIconSize = screenWidth * 0.055;
    final double appBarTitleFontSize =
        isTablet ? screenWidth * 0.04 : screenWidth * 0.055;

    return Consumer<HomeController>(
      builder: (context, homeController, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: appBarLeadingIconSize,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Categories',
              style: TextStyle(
                color: Colors.black,
                fontSize: appBarTitleFontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'times new roman',
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              _buildCategoryTabs(context, homeController),
              Expanded(
                child:
                    homeController.isLoadingHeadlines
                        ? const Center(child: CircularProgressIndicator())
                        : homeController.topHeadlines.isEmpty
                        ? const Center(child: Text('No news available'))
                        : ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding,
                          ),
                          itemCount: homeController.topHeadlines.length,
                          separatorBuilder:
                              (_, __) => SizedBox(height: screenHeight * 0.02),
                          itemBuilder:
                              (_, index) => _NewsHorizontalCard(
                                article: homeController.topHeadlines[index],
                              ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryTabs(
    BuildContext context,
    HomeController homeController,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    final double tabContainerHeight = screenHeight * 0.06;
    final double tabPaddingVertical = screenHeight * 0.01;
    final double tabPaddingHorizontal = screenWidth * 0.04;
    final double tabFontSize =
        isTablet ? screenWidth * 0.025 : screenWidth * 0.04;
    final double indicatorWidth = screenWidth * 0.1;
    final double indicatorHeight = screenHeight * 0.0025;
    final double indicatorTopMargin = screenHeight * 0.005;

    return Container(
      height: tabContainerHeight,
      padding: EdgeInsets.symmetric(vertical: tabPaddingVertical),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: homeController.categories.length,
        itemBuilder: (context, index) {
          final category = homeController.categories[index];
          bool isSelected = homeController.selectedCategory == category;
          return GestureDetector(
            onTap: () => homeController.changeCategory(category),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tabPaddingHorizontal),
              child: Column(
                children: [
                  Text(
                    category[0].toUpperCase() + category.substring(1),
                    style: TextStyle(
                      color: isSelected ? Colors.red : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: tabFontSize,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: EdgeInsets.only(top: indicatorTopMargin),
                      height: indicatorHeight,
                      width: indicatorWidth,
                      color: Colors.red,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NewsHorizontalCard extends StatelessWidget {
  final NewsArticleModel article;

  const _NewsHorizontalCard({required this.article});

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
    final double bookmarkPaddingLeft = screenWidth * 0.02;
    final double bookmarkPaddingTop = screenHeight * 0.025;
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
              GestureDetector(
                onTap: () {
                  if (isBookmarked) {
                    bookmarkController.removeBookmark(article.url);
                  } else {
                    bookmarkController.addBookmark(article);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: bookmarkPaddingLeft,
                    top: bookmarkPaddingTop,
                  ),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.red : Colors.black,
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
