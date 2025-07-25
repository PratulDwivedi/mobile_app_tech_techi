import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:mobile_app_tech_techi/services/navigation_service.dart';
import '../config/app_config.dart';
import '../models/page_item.dart';
import '../models/screen_args_model.dart';
import '../utils/icon_utils.dart';
import 'package:url_launcher/url_launcher.dart';

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
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            _buildDrawerHeader(context),
            if (features.isNotEmpty) ...[
              ...features
                  .map((page) => _buildDrawerItem(context, page, level: 0)),
            ],
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(LucideIcons.info),
              title: Text('${appConfig.appName} ${appConfig.appVersion}'),
              onTap: () {
                launchUrl(Uri.parse(appConfig.webSiteUrl));
              },
            ),
          ],
        ),
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


  Widget _buildDrawerItem(BuildContext context, PageItem page,
      {int level = 0}) {
    final isExpandable = page.children.isNotEmpty;
    final double indent = 16.0 + 20.0 * level;
    final Color accent =
        Theme.of(context).colorScheme.primary.withOpacity(0.10);
    final Color accentLine =
        Theme.of(context).colorScheme.primary.withOpacity(0.25);

    Widget content = isExpandable
        ? Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.only(left: indent, right: 8),
              leading: Icon(getIconFromString(page.itemIcon), size: 22),
              title: Text(
                page.name,
                style: TextStyle(
                  fontWeight: level == 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              backgroundColor: level > 0 ? accent : null,
              collapsedBackgroundColor:
                  level > 0 ? accent.withOpacity(0.7) : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              trailing:
                  const Icon(Icons.expand_more, size: 20, color: Colors.grey),
              children: page.children
                  .map((child) =>
                      _buildDrawerItem(context, child, level: level + 1))
                  .toList(),
            ),
          )
        : ListTile(
            contentPadding: EdgeInsets.only(left: indent, right: 16),
            leading: Icon(getIconFromString(page.itemIcon), size: 22),
            title: Text(
              page.name,
              style: TextStyle(
                fontWeight: level == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            tileColor: level > 0 ? accent : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onTap: () {
              Navigator.of(context).pop();
              NavigationService.navigateTo(
                page.routeName,
                arguments: ScreenArgsModel(
                    routeName: page.routeName,
                    pageName: page.name,
                    isHome: false),
              );
            },
          );

    if (level == 0) return content;

    // Add vertical accent line for nested levels
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 16.0 + 20.0 * (level - 1)),
        Container(width: 3, height: 48, color: accentLine),
        Expanded(child: content),
      ],
    );
  }
}
