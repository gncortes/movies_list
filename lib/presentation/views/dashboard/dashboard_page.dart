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
        actions: [
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh))
        ],
      ),
      body: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: controller.yearsNotifier,
                  builder: (context, value, child) {
                    return switch (value) {
                      DashboardYearsLoadingState() => const CenteredLoading(),
                      DashboardYearsSuccessState() =>
                        YearCard(years: value.years),
                      DashboardYearsErrorState() => CustomErrorWidget(
                          error: (value).error,
                          onRetry: controller.getYearsWithMoreThanOneWinner,
                        ),
                      _ => const SizedBox.shrink(),
                    };
                  },
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: controller.studiosNotifier,
                  builder: (context, value, child) {
                    return switch (value) {
                      DashboardStudiosLoadingState() => const CenteredLoading(),
                      DashboardStudiosSuccessState() =>
                        StudiosCard(studios: value.studios),
                      DashboardStudiosErrorState() => CustomErrorWidget(
                          error: (value).error,
                          onRetry: controller.getStudiosWithTheMostWins,
                        ),
                      _ => const SizedBox.shrink(),
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
    _reload();
    super.initState();
  }

  void _reload() {
    controller.getStudiosWithTheMostWins();
    controller.getYearsWithMoreThanOneWinner();
  }
}
