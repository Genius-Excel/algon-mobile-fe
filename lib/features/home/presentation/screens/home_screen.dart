import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/bottom_nav_bar.dart';
import '../widgets/apply_card.dart';
import '../widgets/digitize_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_application_card.dart';

@RoutePage(name: 'Home')
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: const EdgeInsets.all(24),
              child: const Row(
                children: [
                  Text(
                    'LGCIVS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Welcome message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, John',
                    style: AppStyles.textStyle.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your certificates',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ApplyCard(),
                    SizedBox(height: 16),
                    DigitizeCard(),
                    SizedBox(height: 24),
                    QuickActions(),
                    SizedBox(height: 24),
                    // Recent Applications
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent Applications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    RecentApplicationCard(
                      id: 'CERT-2025-001',
                      location: 'Ikeja LGA',
                      date: '2025-10-15',
                      status: 'Approved',
                    ),
                    SizedBox(height: 12),
                    RecentApplicationCard(
                      id: 'DIGI-2025-012',
                      location: 'Ikeja LGA',
                      date: '2025-10-23',
                      status: 'Approved',
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}
