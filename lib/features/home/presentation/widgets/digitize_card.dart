import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';

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
                CustomButton(
                  text: 'Digitize It',
                  iconData: Icons.download,
                  variant: ButtonVariant.outline,
                  onPressed: () {},
                  backgroundColor: const Color(0xFFE8F5E3),
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
