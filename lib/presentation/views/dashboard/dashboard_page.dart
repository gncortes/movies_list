import 'package:flutter/material.dart';

import 'dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  final DashboardController controller;
  const DashboardPage({super.key, required this.controller});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
