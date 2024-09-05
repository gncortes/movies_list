import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dashboard_states.dart';

class MoviesSearchWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final ValueNotifier<DashboardMovieSearchState> searchNotifier;
  final Function(String) onSearch;

  const MoviesSearchWidget({
    super.key,
    required this.searchNotifier,
    required this.onSearch,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Apenas números
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Digite o ano',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    final year = textEditingController.text;
                    if (year.isNotEmpty) {
                      onSearch(year);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Por favor, insira um ano válido')),
                      );
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
        ),
        ValueListenableBuilder<DashboardMovieSearchState>(
          valueListenable: searchNotifier,
          builder: (context, state, _) {
            return switch (state) {
              DashboardMovieSearchLoadingState() =>
                const CircularProgressIndicator(), // Exibe o loading
              DashboardMovieSearchSuccessState() => Column(
                  children: state.movies.map((movie) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text(movie.title),
                        subtitle: Text('Ano: ${movie.year}'),
                        tileColor: Colors.grey[200], // Apenas para estilo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              DashboardMovieSearchErrorState() => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(state.error.message),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ],
    );
  }
}
