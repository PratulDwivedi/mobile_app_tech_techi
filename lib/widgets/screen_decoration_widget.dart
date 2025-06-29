import 'package:flutter/material.dart';

class ScreenDecorationWidget extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  final Color primaryColor;

  const ScreenDecorationWidget({
    super.key,
    required this.child,
    required this.isDarkMode,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1a1a2e),
                  const Color(0xFF16213e),
                  const Color(0xFF0f3460),
                ]
              : [
                  primaryColor.withOpacity(0.1),
                  primaryColor.withOpacity(0.05),
                  Colors.white,
                ],
        ),
      ),
      child: child,
    );
  }
}
