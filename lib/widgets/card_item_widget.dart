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
        childAspectRatio: 1.3,
        children: List.generate(4, (_) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(height: 160),
        )),
      ),
      error: (e, st) => Center(child: Text('Error loading cards')),
      data: (items) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 1.3,
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
  const CardItemWidget({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.13),
            theme.colorScheme.secondary.withOpacity(0.13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.subTitle, style: theme.textTheme.bodySmall),
                //Text(item.subTitle2, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.value,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: item.iconSymbol == 'plus' ? Colors.green : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(
                getIconFromString(item.itemIcon),
                size: 32,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
