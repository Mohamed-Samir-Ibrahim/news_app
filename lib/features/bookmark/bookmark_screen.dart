import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/time_extension.dart';
import '../layout/news_details_screen.dart';
import 'bookmark_controller.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Bookmarks',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.black,
              fontSize: 24,
              letterSpacing: 3,
              fontFamily: 'times new roman',
            ),
          ),
        ),
      ),
      // backgroundColor: Color(0xFFf8f4f4),
      body: Consumer<BookmarkController>(
        builder: (
          BuildContext context,
          BookmarkController controller,
          Widget? child,
        ) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String? title = controller.bookmarks[index].title,
                      sourceName = controller.bookmarks[index].sourceName;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return NewsDetailsScreen(
                              article: controller.bookmarks[index],
                              isBookmarked: controller.isBookmarked(
                                controller.bookmarks[index].url,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(12),

                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.3),
                        //     spreadRadius: 2,
                        //     blurRadius: 8,
                        //     offset: Offset(0, 4),
                        //   ),
                        // ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 18),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: CachedNetworkImage(
                                imageUrl:
                                    controller.bookmarks[index].urlToImage ??
                                    "",
                                placeholder:
                                    (_, __) => Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      color: Colors.grey.shade400,
                                    ),
                                errorWidget:
                                    (_, __, ___) => Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      color: Colors.grey.shade400,
                                    ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              title != null
                                  ? title.length > 20
                                      ? title.substring(0, 20)
                                      : title
                                  : "",
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(letterSpacing: 2),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage: CachedNetworkImageProvider(
                                    controller.bookmarks[index].urlToImage ??
                                        "",
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  sourceName != null
                                      ? sourceName.length > 15
                                          ? sourceName.substring(0, 15)
                                          : sourceName
                                      : "",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    letterSpacing: 2,
                                    fontFamily: 'popins',
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 18),
                                Text(
                                  ((controller.bookmarks[index].publishedAt
                                          as DateTime))
                                      .formatTimeAgo(),
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(letterSpacing: 2),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    if (!controller.isBookmarked(
                                      controller.bookmarks[index].url,
                                    )) {
                                      controller.addBookmark(
                                        controller.bookmarks[index],
                                      );
                                    } else {
                                      controller.removeBookmark(
                                        controller.bookmarks[index].url,
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    controller.isBookmarked(
                                          controller.bookmarks[index].url,
                                        )
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color:
                                        controller.isBookmarked(
                                              controller.bookmarks[index].url,
                                            )
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
                      ),
                    ),
                  );
                },

                itemCount: controller.bookmarks.length,
              ),
            ),
          );
        },
      ),
    );
  }
}
