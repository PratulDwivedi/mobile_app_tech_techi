import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_app_tech_techi/services/auth/auth_service.dart';
import 'package:mobile_app_tech_techi/widgets/theme_selector.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOption>(
      icon: const Icon(LucideIcons.moreVertical),
      onSelected: (option) async {
        switch (option) {
          case _MenuOption.logout:
            await AuthService.instance.signOut();
            break;
          case _MenuOption.theme:
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => const ThemeSelector(),
            );
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MenuOption.logout,
          child: Row(
            children: [
              Icon(LucideIcons.logOut, color: Colors.red, size: 20),
              const SizedBox(width: 10),
              const Text('Exit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MenuOption.theme,
          child: Row(
            children: [
              Icon(LucideIcons.sunMoon, color: Colors.amber, size: 20),
              const SizedBox(width: 10),
              const Text('Theme Picker'),
            ],
          ),
        ),
      ],
    );
  }
}

enum _MenuOption { logout, theme } 