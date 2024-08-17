import 'package:flutter/material.dart';
import 'package:meta_bio/ui/component/shimmer_container.dart';
import 'package:shimmer/shimmer.dart';

class ModulesShimmerList extends StatelessWidget {
  const ModulesShimmerList({super.key});

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
          return const Card(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(radius: 24),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(width: 160, height: 20),
                      SizedBox(height: 4),
                      ShimmerContainer(width: 100, height: 20),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
