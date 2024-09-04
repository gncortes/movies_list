import 'package:flutter/material.dart';

import '../../domain/failures/custom_error.dart';

class CustomErrorWidget extends StatelessWidget {
  final CustomError error;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            error.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
        // Botão de tentar novamente
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }
}
