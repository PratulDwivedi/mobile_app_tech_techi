import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:mobile_app_tech_techi/models/page_item.dart';
import 'package:mobile_app_tech_techi/services/navigation_service.dart';
import '../providers/riverpod/theme_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  final List<PageItem> pages;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.pages,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    // Get all pages recursively and filter for quick links that have no children
    final allPages = _getAllPagesRecursively(pages);
    final quickLinks = allPages
        .where((p) =>
            p.displayLocationId == PageDisplayLocations.quicklist &&
            p.children.isEmpty)
        .toList();

    // Limit to 4 items for bottom navigation
    final navigationItems = quickLinks.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Quick links
              ...navigationItems.asMap().entries.map((entry) {
                final index = entry.key + 1; // +1 because 0 is home
                final page = entry.value;
                return _buildNavigationItem(
                  context: context,
                  ref: ref,
                  icon: getIconFromString(page.itemIcon),
                  label: page.name,
                  isSelected: currentIndex == index,
                  onTap: () {
                    onTap(index);
                    NavigationService.navigateTo(page.routeName, arguments: {'isHome': false});
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get all pages recursively (including children)
  List<PageItem> _getAllPagesRecursively(List<PageItem> pages) {
    List<PageItem> allPages = [];

    for (final page in pages) {
      allPages.add(page);
      if (page.children.isNotEmpty) {
        allPages.addAll(_getAllPagesRecursively(page.children));
      }
    }

    return allPages;
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required WidgetRef ref,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primaryColor = ref.watch(primaryColorProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? primaryColor
                  : (isDarkMode ? Colors.white70 : Colors.black54),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? primaryColor
                    : (isDarkMode ? Colors.white70 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 