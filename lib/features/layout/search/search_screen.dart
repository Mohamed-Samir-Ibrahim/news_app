import 'package:flutter/material.dart';
import 'package:news_app/features/layout/search/search_controller.dart';
import 'package:provider/provider.dart';

import '../../../shared/news_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchController1>(
      create: (context) => SearchController1(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf8f4f4),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Search for Articles',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'times new roman',
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<SearchController1>(
            builder: (context, controller, child) {
              return Column(
                children: [
                  TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search news...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          controller.searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  controller.searchController.clear();
                                  controller.searchNews('');
                                  setState(() {});
                                },
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (value) => controller.searchNews(value),
                    onChanged: (value) {
                      setState(() {}); // لتحديث ظهور زر الـ clear
                    },
                  ),
                  const SizedBox(height: 16),
                  if (controller.isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.error != null)
                    Expanded(
                      child: Center(
                        child: Text(
                          controller.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  else if (controller.res.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              controller.searchController.text.isEmpty
                                  ? 'Type something to search'
                                  : 'No articles found',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.res.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return NewsCard(article: controller.res[index]);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
