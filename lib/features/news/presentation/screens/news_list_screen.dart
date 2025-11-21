import 'package:appzoque/features/news/presentation/screens/news_detail_screen.dart';
import 'package:appzoque/features/news/presentation/viewmodels/news_viewmodel.dart';
import 'package:appzoque/features/news/presentation/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  @override
  void initState() {
    super.initState();
    // Load news when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.newsItems.isEmpty) {
          return Container(
            color: Colors.grey.shade50,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (viewModel.error != null && viewModel.newsItems.isEmpty) {
          return Container(
            color: Colors.grey.shade50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar noticias',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.error!,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadNews(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          color: Colors.grey.shade50,
          child: RefreshIndicator(
            onRefresh: () => viewModel.loadNews(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: viewModel.newsItems.length,
              itemBuilder: (context, index) {
                final newsItem = viewModel.newsItems[index];
                return NewsCard(
                  newsItem: newsItem,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailScreen(newsItem: newsItem),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
