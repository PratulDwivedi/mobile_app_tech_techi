import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final Object error;
  final bool isDarkMode;

  const CustomErrorWidget({
    super.key,
    required this.error,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $error',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
