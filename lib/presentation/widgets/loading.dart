import 'package:flutter/material.dart';

class CenteredLoading extends StatelessWidget {
  const CenteredLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
