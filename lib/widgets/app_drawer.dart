import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:mobile_app_tech_techi/services/navigation_service.dart';
import '../models/page_item.dart';
import '../models/screen_args_model.dart';
import '../utils/icon_utils.dart';

class AppDrawer extends StatelessWidget {
  final List<PageItem> pages;
  final Map<String, dynamic>?
      userProfile; // Should contain name, email, tenant_name
  const AppDrawer({super.key, required this.pages, this.userProfile});

  @override
  Widget build(BuildContext context) {
    // Only show features (displayLocationId == sidebar), remove quick links
    final features = pages
        .where((p) => p.displayLocationId == PageDisplayLocations.sidebar)
        .toList();

    return Drawer(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerHeader(context),
              if (features.isNotEmpty) ...[
                _buildSectionHeader('FEATURES'),
                ...features.map((page) => _buildDrawerItem(context, page)),
              ],
              const SizedBox(height: 80), // Space for version info at bottom
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ListTile(
              leading: const Icon(LucideIcons.info),
              title: const Text('v0.0.1'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final name = userProfile?['full_name'] ?? 'User';
    final email = userProfile?['email'] ?? '';
    final tenant = userProfile?['tenant_name'] ?? '';
    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                name.isNotEmpty ? name[0] : '?',
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (tenant.isNotEmpty)
                    Text(
                      tenant,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.purple,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.x),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, PageItem page) {
    if (page.children.isEmpty) {
      return ListTile(
        leading: Icon(getIconFromString(page.itemIcon)),
        title: Text(page.name),
        onTap: () {
          Navigator.of(context).pop();
          NavigationService.navigateTo(
            page.routeName,
            arguments: ScreenArgsModel(
                routeName: page.routeName, pageName: page.name, isHome: false),
          );
        },
      );
    } else {
      return ExpansionTile(
        leading: Icon(getIconFromString(page.itemIcon)),
        title: Text(page.name),
        children: page.children
            .map((child) => _buildDrawerItem(context, child))
            .toList(),
      );
    }
  }
}
