import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.deepPurple;

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;

  final List<Color> _colorOptions = [
    Colors.deepPurple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.red,
  ];

  List<Color> get colorOptions => _colorOptions;

  ThemeProvider() {
    loadTheme();
  }

  ThemeData getTheme() {
    final theme = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: _primaryColor,
        secondary: _primaryColor,
      ),
    );
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _saveTheme();
  }

  void setColor(Color color) {
    _primaryColor = color;
    notifyListeners();
    _saveTheme();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setInt('primaryColor', _primaryColor.value);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final colorValue = prefs.getInt('primaryColor');
    if (colorValue != null) {
      _primaryColor = Color(colorValue);
    }
    notifyListeners();
  }
} 