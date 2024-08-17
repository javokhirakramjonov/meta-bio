import 'package:flutter/material.dart';
import 'package:meta_bio/ui/component/shimmer_container.dart';
import 'package:shimmer/shimmer.dart';

class ExamsShimmerList extends StatelessWidget {
  const ExamsShimmerList({super.key});

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
          return const _ExamItemShimmer();
        },
      ),
    );
  }
}

class _ExamItemShimmer extends StatelessWidget {
  const _ExamItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 8),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerContainer(width: double.infinity, height: 20),
            SizedBox(height: 16),
            Divider(height: 32, color: Color(0xFF1C1C1C)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ShimmerContainer(width: 100, height: 20),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ShimmerContainer(width: 100, height: 20),
                ),
              ],
            ),
            SizedBox(height: 16),
            ShimmerContainer(width: double.infinity, height: 20),
          ],
        ),
      ),
    );
  }
}
