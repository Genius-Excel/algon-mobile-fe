import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';

class ApplyCard extends StatelessWidget {
  const ApplyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065F46), Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Apply for Certificate',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start a new indigene certificate application',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'New Application',
                  iconData: Icons.add,
                  variant: ButtonVariant.secondary,
                  onPressed: () {
                    context.router.pushNamed('/application/step1');
                  },
                  backgroundColor: const Color(0xFFE8F5E3),
                  textColor: const Color(0xFF065F46),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.description, size: 80, color: Colors.white30),
        ],
      ),
    );
  }
}
