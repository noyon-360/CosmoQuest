import 'dart:convert';
import 'package:cosmoquest/Model/Nasa/article_model.dart';
import 'package:cosmoquest/Utils/apis.dart';
import 'package:http/http.dart' as http;

class NasaService {
  final String baseUrl = 'https://api.nasa.gov/planetary/apod?api_key=${Apis.nasaApi}';

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return [Article.fromJson(data)];
      }
    }
    return []; // Return an empty list if no data found
  }
}
