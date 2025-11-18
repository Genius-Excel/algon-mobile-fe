import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/core/router/router.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionCard(
          icon: Icons.search,
          text: 'Track Status',
          onTap: () => context.router.push(const Tracking()),
        ),
        _ActionCard(
          icon: Icons.verified,
          text: 'Verify',
          onTap: () => context.router.push(const VerifyCertificate()),
        ),
        _ActionCard(
          icon: Icons.notifications,
          text: 'Alerts',
          hasBadge: true,
          onTap: () => context.router.push(const Alerts()),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasBadge;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.icon,
    required this.text,
    this.hasBadge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(icon, size: 32, color: const Color(0xFF065F46)),
                if (hasBadge)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF065F46),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
