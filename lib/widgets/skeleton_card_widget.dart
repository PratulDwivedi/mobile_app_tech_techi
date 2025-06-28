import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCardWidget extends StatelessWidget {
  final int fieldCount;

  const SkeletonCardWidget({
    super.key,
    this.fieldCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < fieldCount; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label skeleton
                      Container(
                        width: 80,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Value skeleton
                      Expanded(
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < fieldCount - 1) const SizedBox(height: 12),
              ],
              // Action buttons skeleton
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 80,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonCardListWidget extends StatelessWidget {
  final int cardCount;
  final int fieldCount;

  const SkeletonCardListWidget({
    super.key,
    this.cardCount = 5,
    this.fieldCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cardCount,
      itemBuilder: (context, index) {
        return SkeletonCardWidget(fieldCount: fieldCount);
      },
    );
  }
}
