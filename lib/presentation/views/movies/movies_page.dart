import 'package:flutter/material.dart';

import '../../widgets/drawer/custom_drawer.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

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
