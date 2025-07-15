import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/card_item_model.dart';
import '../utils/icon_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/riverpod/data_providers.dart';

class CardItemListWidget extends ConsumerWidget {
  final String bindingName;
  const CardItemListWidget({required this.bindingName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(bindingListProvider(bindingName));
    return asyncValue.when(
      loading: () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 1.2,
        children: List.generate(4, (_) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(height: 140),
        )),
      ),
      error: (e, st) => Center(child: Text('Error loading cards')),
      data: (items) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 1.2,
        children: (items as List)
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
  const CardItemWidget({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 140),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.35),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item.subTitle, style: theme.textTheme.bodySmall),
                      Text(item.subTitle2,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor)),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(getIconFromString(item.iconSymbol), size: 20),
                          const SizedBox(width: 4),
                          Text(
                            item.value,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(getIconFromString(item.itemIcon),
                        size: 28, color: theme.colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
