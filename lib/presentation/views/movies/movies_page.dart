import 'package:flutter/material.dart';
import '../../widgets/drawer/custom_drawer.dart';
import 'movies_controller.dart';
import 'movies_state.dart';

class MoviesPage extends StatefulWidget {
  final MoviesController controller;
  const MoviesPage({super.key, required this.controller});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  MoviesController get controller => widget.controller;
  final TextEditingController _yearController = TextEditingController();

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ano',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: controller.winnerFilterNotifier,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<bool>(
                        value: value,
                        decoration: const InputDecoration(
                          labelText: 'Vencedor',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: false, child: Text('Não')),
                          DropdownMenuItem(value: true, child: Text('Sim')),
                        ],
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            controller.setWinnerFilter(newValue);
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_yearController.text.isNotEmpty) {
                        controller.getMoviesByYear(_yearController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: controller.moviesNotifier,
                builder: (context, value, _) {
                  return switch (value) {
                    MoviesLoadingState() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    MoviesSuccessState() => Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: value.movies.length,
                              itemBuilder: (context, index) {
                                final movie = value.movies[index];
                                return ListTile(
                                  title: Text(movie.title),
                                  subtitle: Text(
                                      'Ano: ${movie.year} | Vencedor: ${movie.winner ? "Sim" : "Não"}'),
                                );
                              },
                            ),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: controller.currentPageNotifier,
                            builder: (context, currentPage, _) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (currentPage > 1)
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.previousPage(
                                          _yearController.text,
                                        );
                                      },
                                      child: const Text('Página Anterior'),
                                    ),
                                  if (currentPage < value.totalPages)
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.nextPage(
                                          _yearController.text,
                                        );
                                      },
                                      child: const Text('Próxima Página'),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    MoviesErrorState() => Center(
                        child: Text('Erro: ${value.error.message}'),
                      ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
