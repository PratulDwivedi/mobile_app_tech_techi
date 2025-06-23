import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_item.dart';
import 'package:mobile_app_tech_techi/services/navigation_service.dart';
import '../providers/riverpod/theme_provider.dart';
import '../providers/riverpod/data_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PageItem> _allPages = [];
  List<PageItem> _filteredPages = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredPages = List<PageItem>.from(_allPages);
        _isSearching = false;
      });
    } else {
      setState(() {
        _isSearching = true;
        _filteredPages = _allPages.where((page) {
          return page.name.toLowerCase().contains(query) ||
                 (page.descr?.toLowerCase().contains(query) ?? false);
        }).toList();
      });
    }
  }

  List<PageItem> _getAllChildPages(List<PageItem> pages) {
    List<PageItem> allPages = [];
    
    for (final page in pages) {
      if (page.children.isNotEmpty) {
        allPages.addAll(_getAllChildPages(page.children));
      } else {
        // Only add pages that have no children (actual navigable pages)
        allPages.add(page);
      }
    }
    
    return allPages;
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);
    final userPagesAsync = ref.watch(userPagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      body: Container(
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
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
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
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for pages...',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      color: primaryColor,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              LucideIcons.x,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            
            // Search Results
            Expanded(
              child: userPagesAsync.when(
                data: (pages) {
                  // Initialize all pages if not done yet
                  if (_allPages.isEmpty) {
                    _allPages = _getAllChildPages(pages);
                    _filteredPages = List<PageItem>.from(_allPages);
                  }

                  // Show all pages by default, or filtered results if searching
                  final pagesToShow = _isSearching ? _filteredPages : _allPages;

                  if (pagesToShow.isEmpty) {
                    if (_isSearching) {
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
                              Icon(
                                LucideIcons.searchX,
                                size: 48,
                                color: primaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No results found for "${_searchController.text}"',
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
                    } else {
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
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: primaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No pages found',
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

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: pagesToShow.length,
                    itemBuilder: (context, index) {
                      final page = pagesToShow[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              getIconFromString(page.itemIcon),
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            page.name,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: page.descr != null && page.descr!.isNotEmpty
                              ? Text(
                                  page.descr!,
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white70 : Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: Icon(
                            LucideIcons.arrowRight,
                            color: primaryColor,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            NavigationService.navigateTo(page.routeName);
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                error: (error, stack) => Center(
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
                        Icon(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 