import 'package:flutter/material.dart';

import '../../widgets/drawer/custom_drawer.dart';
import 'movies_controller.dart';

class MoviesPage extends StatefulWidget {
  final MoviesController controller;
  const MoviesPage({super.key, required this.controller});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        currentRoute: ModalRoute.of(context)!.settings.name ?? '',
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Filmes'),
      ),
    );
  }
}
