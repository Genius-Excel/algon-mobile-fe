import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';

class ShimmerApplicationCard extends StatelessWidget {
  const ShimmerApplicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(width: 120, height: 16),
                    SizedBox(height: 8),
                    ShimmerContainer(width: 100, height: 12),
                    SizedBox(height: 8),
                    ShimmerContainer(width: 150, height: 12),
                    SizedBox(height: 8),
                    ShimmerContainer(width: 80, height: 12),
                  ],
                ),
              ),
              ShimmerContainer(width: 60, height: 24),
            ],
          ),
          SizedBox(height: 12),
          ShimmerContainer(width: 80, height: 20),
        ],
      ),
    );
  }
}
