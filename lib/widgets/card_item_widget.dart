import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/card_item_model.dart';
import '../utils/icon_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/riverpod/data_providers.dart';
import '../services/navigation_service.dart';
import '../utils/navigation_utils.dart';

class CardItemListWidget extends ConsumerWidget {
  final String bindingName;
  const CardItemListWidget({required this.bindingName, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(bindingListProvider(bindingName));
    return asyncValue.when(
      loading: () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.3,
        children: List.generate(
            4,
            (_) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(height: 160),
                )),
      ),
      error: (e, st) => const Center(child: Text('Error loading cards')),
      data: (items) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.3,
        children: (items)
            .map((item) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CardItemWidget(item: CardItemModel.fromJson(item)),
                ))
            .toList(),
      ),
    );
  }
}


class CardItemWidget extends StatelessWidget {
  final CardItemModel item;
  const CardItemWidget({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: item.url.isNotEmpty
          ? () {
              final parseRouteResult = parseRouteAndArgs(item.url, item.toJson());
              NavigationService.navigateTo(parseRouteResult.routeName, arguments: parseRouteResult.args);
            }
          : null,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark 
              ? Colors.white.withOpacity(0.2) 
              : Colors.white.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark 
                ? Colors.black.withOpacity(0.3) 
                : Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: isDark 
                ? Colors.white.withOpacity(0.05) 
                : Colors.white.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(isDark ? 0.08 : 0.15),
                    theme.colorScheme.secondary.withOpacity(isDark ? 0.06 : 0.12),
                    theme.colorScheme.tertiary.withOpacity(isDark ? 0.04 : 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // Additional overlay for glass effect
                backgroundBlendMode: BlendMode.overlay,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(isDark ? 0.05 : 0.25),
                      Colors.white.withOpacity(isDark ? 0.02 : 0.10),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Title and subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subTitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              item.subTitle2,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right: Icon and value
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.surface.withOpacity(isDark ? 0.3 : 0.7),
                                  theme.colorScheme.surface.withOpacity(isDark ? 0.2 : 0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              getIconFromString(item.itemIcon),
                              size: 20,
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                item.value,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}