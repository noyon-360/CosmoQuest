import 'package:cosmoquest/Model/Nasa/article_model.dart';
import 'package:cosmoquest/Service/Nasa/nasa_service.dart';
import 'package:flutter/material.dart';


class NasaDocumentViewModel extends ChangeNotifier {
  final NasaService _nasaService = NasaService();
  List<Article> _articles = [];
  bool _isLoading = true;
  String? _error;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NasaDocumentViewModel(String apiUrl) {
    fetchArticles(apiUrl);
  }

  Future<void> fetchArticles(String apiUrl) async {
    try {
      _isLoading = true;
      notifyListeners();

      _articles = await _nasaService.fetchArticles();
      _error = null; // Reset error on successful fetch
    } catch (e) {
      _error = e.toString(); // Capture the error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
