import 'package:flutter/material.dart';
import 'package:movies_list/data/data.dart';
import 'package:movies_list/presentation/views/views.dart';

import 'infrastructure/http_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final dashboardController = DashboardController(
    MoviesDatasource(HttpServiceImplementation()),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) =>
            DashboardPage(controller: dashboardController),
        '/movies': (context) => const MoviesPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
