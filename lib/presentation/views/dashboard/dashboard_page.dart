import 'package:flutter/material.dart';

import '../../widgets/error.dart';
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
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: controller.yearsNotifier,
                  builder: (context, value, child) {
                    return switch (value) {
                      DashboardYearsLoadingState() =>
                        const Center(child: CircularProgressIndicator()),
                      DashboardYearsSuccessState() =>
                        YearCard(years: value.years),
                      DashboardYearsErrorState() => CustomErrorWidget(
                          error: (value).error,
                          onRetry: controller.getYearsWithMoreThanOneWinner,
                        ),
                      _ => const SizedBox
                          .shrink(), // Fallback para estados desconhecidos
                    };
                  },
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: controller.studiosNotifier,
                  builder: (context, value, child) {
                    return switch (value) {
                      DashboardStudiosLoadingState() =>
                        const Center(child: CircularProgressIndicator()),
                      DashboardStudiosSuccessState() =>
                        StudiosCard(studios: value.studios),
                      DashboardStudiosErrorState() => CustomErrorWidget(
                          error: (value).error,
                          onRetry: controller.getStudiosWithTheMostWins,
                        ),
                      _ => const SizedBox
                          .shrink(), // Fallback para estados desconhecidos
                    };
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    controller.getStudiosWithTheMostWins();
    controller.getYearsWithMoreThanOneWinner();
    super.initState();
  }
}
