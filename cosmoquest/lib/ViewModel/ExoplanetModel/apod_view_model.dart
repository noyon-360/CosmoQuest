// viewmodel/apod_view_model.dart
import 'package:cosmoquest/Model/ExoplanetModel/APODDataModel.dart';
import 'package:cosmoquest/Utils/apis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APODViewModel extends ChangeNotifier {
  List<APODData> _apodList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<APODData> get apodList => _apodList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAPODData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await http.get(
      Uri.parse('https://api.nasa.gov/planetary/apod?api_key=${Apis.nasaApi}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      _apodList = jsonData.map((json) => APODData.fromJson(json)).toList();
    } else {
      _errorMessage = 'Failed to load data';
    }
    print(_apodList);
    _isLoading = false;
    notifyListeners();
  }
}
