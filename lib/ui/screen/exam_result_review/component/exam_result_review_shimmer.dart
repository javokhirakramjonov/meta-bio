import 'package:flutter/material.dart';
import 'package:meta_bio/ui/component/shimmer_container.dart';
import 'package:shimmer/shimmer.dart';

class ExamResultReviewShimmer extends StatelessWidget {
  const ExamResultReviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primary,
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return const _ExamResultReviewItemShimmer();
        },
      ),
    );
  }
}

class _ExamResultReviewItemShimmer extends StatelessWidget {
  const _ExamResultReviewItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                ShimmerContainer(width: 100, height: 30),
                Spacer(),
                ShimmerContainer(width: 100, height: 30),
              ],
            ),
            const SizedBox(height: 16),
            const ShimmerContainer(width: double.infinity, height: 50),
            const SizedBox(height: 16),
            ...List.generate(4, (index) {
              return Column(
                children: [
                  const Card(
                      child:
                          ShimmerContainer(width: double.infinity, height: 40)),
                  if (index < 3) const SizedBox(height: 16),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
