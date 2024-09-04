import 'package:flutter/material.dart';

import 'dashboard_controller.dart';
import 'dashboard_states.dart';

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
            children: [
              Expanded(
                child: ValueListenableBuilder<DashboardYearsState>(
                  valueListenable: controller.yearsNotifier,
                  builder: (context, state, _) {
                    if (state is DashboardYearsLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DashboardYearsSuccessState) {
                      return ListView.builder(
                        itemCount: state.years.length,
                        itemBuilder: (context, index) {
                          final year = state.years[index];
                          return ListTile(
                            title: Text('Year: ${year.year}'),
                            subtitle: Text('Winners: ${year.winnerCount}'),
                          );
                        },
                      );
                    } else if (state is DashboardYearsErrorState) {
                      return Center(
                          child: Text('Error: ${state.error.message}'));
                    }
                    return Container();
                  },
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<DashboardStudiosState>(
                  valueListenable: controller.studiosNotifier,
                  builder: (context, state, _) {
                    if (state is DashboardStudiosLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DashboardStudiosSuccessState) {
                      return ListView.builder(
                        itemCount: state.studios.length,
                        itemBuilder: (context, index) {
                          final studio = state.studios[index];
                          return ListTile(
                            title: Text('Studio: ${studio.name}'),
                            subtitle: Text('Wins: ${studio.winCount}'),
                          );
                        },
                      );
                    } else if (state is DashboardStudiosErrorState) {
                      return Center(
                          child: Text('Error: ${state.error.message}'));
                    }
                    return Container();
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
