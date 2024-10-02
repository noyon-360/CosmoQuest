import 'package:cosmoquest/ViewModel/Nasa/nasa_documnet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'article_detail_view.dart';

class NasaDocument extends StatelessWidget {
  final String apiUrl;
  const NasaDocument({super.key, required this.apiUrl});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NasaDocumentViewModel(apiUrl),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Solar System and Exoplanets News'),
        ),
        body: Consumer<NasaDocumentViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (viewModel.error != null) {
              return Center(child: Text('Error: ${viewModel.error}'));
            } else if (viewModel.articles.isEmpty) {
              return Center(child: Text('No articles found.'));
            }

            return ListView.builder(
              itemCount: viewModel.articles.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(viewModel.articles[index].title),
                    subtitle: Text(viewModel.articles[index].date),
                    onTap: () {
                      // Navigate to the article detail view
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailView(article: viewModel.articles[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
