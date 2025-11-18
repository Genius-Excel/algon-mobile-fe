import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';

import '../../../../src/constants/app_colors.dart';

class DigitizeCard extends StatelessWidget {
  const DigitizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Already Have a Certificate?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF065F46),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Digitize your existing paper certificate for a reduced fee',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF047857),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.router.pushNamed('/digitization/step1');
                  },
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.orange, width: 0.1),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Row(
                      children: [
                        Icon(Icons.download,
                            size: 20, color: AppColors.blackColor),
                        SizedBox(width: 10),
                        Text('Digitize It',
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
           
             ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.check_circle, size: 80, color: Color(0xFF90E8A7)),
        ],
      ),
    );
  }
}
