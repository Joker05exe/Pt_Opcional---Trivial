import 'package:flutter/material.dart';

class CategoryColors {
  // Mapa de colors estàtic
  static final Map<String, Color> _categoryColors = {
    'Entertainment: Video Games': Colors.deepPurple,
    'Entertainment: Film': Colors.redAccent,
    'Entertainment: Music': Colors.pinkAccent,
    'General Knowledge': Colors.orange,
    'Science & Nature': Colors.green,
    'Science: Computers': Colors.blue,
    'History': Colors.brown,
    'Geography': Colors.teal,
    'Sports': Colors.deepOrange,
    'Art': Colors.amber,
  };

  static Color getColor(String category) {
    // Si la categoria conté part de la clau (ex: "Science") també serveix
    for (var key in _categoryColors.keys) {
      if (category.contains(key)) {
        return _categoryColors[key]!;
      }
    }
    // Color per defecte si no es troba
    return Colors.blueGrey;
  }
}