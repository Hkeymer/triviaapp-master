import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultsScreen({super.key, required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Juego Terminado!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              'Tu puntuación: $score / $totalQuestions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Vuelve a la pantalla de inicio
              },
              child: const Text('Jugar de Nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}
