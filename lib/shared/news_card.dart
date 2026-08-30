import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/time_extension.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:provider/provider.dart';

import '../features/layout/news_details_screen.dart';

class NewsCard extends StatelessWidget {
  final NewsArticleModel article;

  const NewsCard({super.key, required this.article});

  // final bookmarksBox = Hive.box<NewsArticleModel>('bookmarks');
  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkController>(
      builder: (
        BuildContext context,
        BookmarkController controller,
        Widget? child,
      ) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return NewsDetailsScreen(article: article);
                },
              ),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? '',
                  fit: BoxFit.cover,
                  width: 170,
                  height: 100,
                  placeholder:
                      (_, __) => Container(
                        height: 100,
                        width: 150,
                        color: Colors.grey.shade400,
                      ),
                  errorWidget:
                      (_, __, ___) => Container(
                        height: 100,
                        width: 150,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          article.title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF141414),
                            letterSpacing: 1,
                            fontFamily: 'times new roman',
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: CachedNetworkImageProvider(
                                  article.urlToImage ?? '',
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                article.sourceName.substring(
                                  0,
                                  8 > article.sourceName.length
                                      ? article.sourceName.length
                                      : 8,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontFamily: 'times new roman'),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                ((article.publishedAt)).formatTimeAgo(),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'times new roman',
                                  letterSpacing: 1,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (!controller.isBookmarked(article.url)) {
                                    // setState(() {
                                    controller.addBookmark(article);
                                    // });
                                  } else {
                                    // setState(() {
                                    controller.removeBookmark(article.url);
                                    // });
                                  }
                                },

                                icon: Icon(
                                  controller.isBookmarked(article.url)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color:
                                      controller.isBookmarked(article.url)
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primary
                                          : Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
