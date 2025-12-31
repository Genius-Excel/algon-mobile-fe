import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ApplicationTab { pending, digitization, approved, rejected }

class ApplicationTabState {
  final ApplicationTab selectedTab;

  ApplicationTabState(this.selectedTab);

  ApplicationTabState copyWith({ApplicationTab? selectedTab}) {
    return ApplicationTabState(selectedTab ?? this.selectedTab);
  }
}

final applicationTabProvider =
    StateNotifierProvider<ApplicationTabNotifier, ApplicationTabState>(
        (ref) => ApplicationTabNotifier());

class ApplicationTabNotifier extends StateNotifier<ApplicationTabState> {
  ApplicationTabNotifier() : super(ApplicationTabState(ApplicationTab.pending));

  void selectTab(ApplicationTab tab) {
    state = state.copyWith(selectedTab: tab);
  }
}

class ApplicationTabs extends ConsumerWidget {
  final List<String> _tabLabels = [
    'Pending',
    'Digitization',
    'Approved',
    'Rejected'
  ];

  ApplicationTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabState = ref.watch(applicationTabProvider);
    final notifier = ref.read(applicationTabProvider.notifier);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(ApplicationTab.values.length, (index) {
            final tab = ApplicationTab.values[index];
            final isSelected = tabState.selectedTab == tab;
            return GestureDetector(
              onTap: () => notifier.selectTab(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF9FAFB)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tabLabels[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}