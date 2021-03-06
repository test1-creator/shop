import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = "https://shop-8ec6f-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/products/$id.json?auth=$authToken";
    try {
      final response = await http.put(Uri.parse(url), body: json.encode(isFavorite));
      if(response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }

  }
}