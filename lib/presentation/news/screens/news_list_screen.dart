import 'package:flutter/material.dart';
import '../../../core/data/news_data.dart';
import '../screens/news_detail_screen.dart';
import '../widgets/news_card.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: NewsData.sampleNews.length,
        itemBuilder: (context, index) {
          final newsItem = NewsData.sampleNews[index];
          return NewsCard(
            newsItem: newsItem,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(newsItem: newsItem),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
