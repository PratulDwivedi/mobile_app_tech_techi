import 'package:flutter/material.dart';

class ActionButtonWithFeedback extends StatelessWidget {
  final IconData iconData;
  final Color? iconColor;
  final String label;
  final VoidCallback onPressed;

  const ActionButtonWithFeedback({
    super.key,
    required this.iconData,
    required this.label,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(iconData, color: iconColor),
      label: Text(label),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(iconColor),
        textStyle: MaterialStateProperty.all(
            const TextStyle(fontWeight: FontWeight.bold)),
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return iconColor?.withOpacity(0.2) ?? Theme.of(context).splashColor;
          }
          if (states.contains(MaterialState.hovered)) {
            return iconColor?.withOpacity(0.08) ?? Theme.of(context).hoverColor;
          }
          return null;
        }),
      ),
      onPressed: onPressed,
    );
  }
}
