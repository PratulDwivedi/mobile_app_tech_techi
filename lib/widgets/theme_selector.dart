import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1a1a2e) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Customize Theme',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Theme Toggle
          _buildThemeToggle(context, themeProvider, isDarkMode, primaryColor),
          const SizedBox(height: 16),
          // Color Picker
          _buildColorPicker(context, themeProvider, isDarkMode),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeProvider themeProvider,
      bool isDarkMode, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color:
            isDarkMode ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeButton(
              context, themeProvider, 'Light', Icons.light_mode, !isDarkMode),
          _buildThemeButton(
              context, themeProvider, 'Dark', Icons.dark_mode, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildThemeButton(BuildContext context, ThemeProvider themeProvider,
      String text, IconData icon, bool isSelected) {
    final primaryColor = themeProvider.primaryColor;
    return GestureDetector(
      onTap: () {
        if ((text == 'Dark' && !themeProvider.isDarkMode) ||
            (text == 'Light' && themeProvider.isDarkMode)) {
          themeProvider.toggleTheme();
          HapticFeedback.lightImpact();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(
      BuildContext context, ThemeProvider themeProvider, bool isDarkMode) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: themeProvider.colorOptions.map((color) {
        bool isSelected = color == themeProvider.primaryColor;
        return GestureDetector(
          onTap: () {
            themeProvider.setColor(color);
            HapticFeedback.lightImpact();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? (isDarkMode ? Colors.white : Colors.black) : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }
} 