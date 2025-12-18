import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:triviaapp/screens/game/game_screen.dart';
import 'package:triviaapp/screens/multiplayer/lobby_screen.dart';
import 'package:triviaapp/screens/game/difficulty_and_topic_screen.dart';
import 'package:triviaapp/data/sample_questions.dart';
import 'package:triviaapp/utils/difficulty_mapper.dart';
import 'package:triviaapp/widgets/game/category_card.dart';

import 'package:triviaapp/widgets/game/countdown_24h.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _startSoloGame(BuildContext context) async {
    final config = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DifficultyAndTopicScreen(isMultiplayer: false),
      ),
    );

    if (config == null) return;

    final difficulty = difficultyFromString(config['difficulty']);
    final topic = config['topic'];

    // TODO: luego integrar Firebase Genkit / Firebase IA aquí
    final questions = sampleQuestions;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          questions: questions,
          autoShuffle: true,
          difficulty: difficulty,
          topic: topic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('TRIVIAPP')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Vidas'),
                      Row(
                        children: const [
                          Icon(Icons.favorite, color: Colors.red, size: 24),
                          SizedBox(width: 4),
                          Text('x 3'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Puntuación'),
                      Row(
                        children: const [
                          Icon(Icons.paid, color: Colors.amber, size: 24),
                          SizedBox(width: 4),
                          Text('x 0'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Se estara recargando tus vidas  x3 en las próximas...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Countdown24h()],
            ),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
              children: [
                CategoryCard(
                  title: 'Historia',
                  color: Colors.blue,
                  icon: Icons.menu_book,
                  checked: true,
                ),
                CategoryCard(
                  title: 'Ciencia',
                  color: Colors.purple,
                  icon: Icons.science,
                  checked: true,
                ),
                CategoryCard(
                  title: 'Deportes',
                  color: Colors.amber,
                  icon: Icons.sports_soccer,
                  checked: false,
                ),
                CategoryCard(
                  title: 'Entretenimiento',
                  color: Colors.red,
                  icon: Icons.movie,
                  checked: true,
                ),
              ],
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Jugar Solo'),
              onPressed: () => _startSoloGame(context),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Multijugador'),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LobbyScreen()),
                ),
              },
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              icon: const Icon(Icons.leaderboard),
              label: const Text('Ranking'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
