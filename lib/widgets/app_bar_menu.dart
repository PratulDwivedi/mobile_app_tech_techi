import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/widgets/theme_selector.dart';
import '../providers/riverpod/service_providers.dart';

class AppBarMenu extends ConsumerWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_MenuOption>(
      icon: const Icon(LucideIcons.moreVertical),
      onSelected: (option) async {
        switch (option) {
          case _MenuOption.logout:
            final authService = ref.read(authServiceProvider);
            await authService.signOut();
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