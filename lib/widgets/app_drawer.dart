import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:mobile_app_tech_techi/services/navigation_service.dart';
import '../models/page_item.dart';

class AppDrawer extends StatelessWidget {
  final List<PageItem> pages;
  const AppDrawer({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    // Only show features (displayLocationId == sidebar), remove quick links
    final features = pages.where((p) => p.displayLocationId == PageDisplayLocations.sidebar).toList();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          if (features.isNotEmpty) ...[
            _buildSectionHeader('FEATURES'),
            ...features.map((page) => _buildDrawerItem(context, page)),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(LucideIcons.info),
            title: const Text('v0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.network(
                    'https://tpgyuqvncljnuyrohqre.supabase.co/storage/v1/object/public/tech-techi-public/images/logo.png',
                    width: 40,
                    height: 40,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(LucideIcons.imageOff, size: 40);
                    },
                  ),
                  const SizedBox(width: 12),
                  const Flexible(
                    child: Text(
                      'Tech Techi',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
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
          NavigationService.navigateTo(page.routeName);
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