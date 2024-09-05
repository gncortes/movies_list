import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import 'dashboard_controller.dart';
import 'dashboard_states.dart';
import 'widgets/widgets.dart';

class DashboardPage extends StatefulWidget {
  final DashboardController controller;
  const DashboardPage({super.key, required this.controller});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardController get controller => widget.controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.showYears(); // Mostrar Anos
                  },
                  child: const Text('Mostrar Anos'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.showStudios();
                  },
                  child: const Text('Mostrar Estúdios'),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<DashboardComponentState>(
            valueListenable: controller.selectedComponentNotifier,
            builder: (context, state, _) {
              return switch (state) {
                ShowYearsState() => ValueListenableBuilder(
                    valueListenable: controller.yearsNotifier,
                    builder: (context, value, _) {
                      return switch (value) {
                        DashboardYearsLoadingState() => const CenteredLoading(),
                        DashboardYearsSuccessState() =>
                          YearCard(years: value.years),
                        DashboardYearsErrorState() => CustomErrorWidget(
                            error: value.error,
                            onRetry: controller.getYearsWithMoreThanOneWinner,
                          ),
                        _ => const SizedBox.shrink(),
                      };
                    },
                  ),
                ShowStudiosState() => ValueListenableBuilder(
                    valueListenable: controller.studiosNotifier,
                    builder: (context, value, _) {
                      return switch (value) {
                        DashboardStudiosLoadingState() =>
                          const CenteredLoading(),
                        DashboardStudiosSuccessState() =>
                          StudiosCard(studios: value.studios),
                        DashboardStudiosErrorState() => CustomErrorWidget(
                            error: value.error,
                            onRetry: controller.getStudiosWithTheMostWins,
                          ),
                        _ => const SizedBox.shrink(),
                      };
                    },
                  ),
                _ => const Center(child: Text('Selecione uma opção')),
              };
            },
          ),
        ],
      ),
    );
  }
}
