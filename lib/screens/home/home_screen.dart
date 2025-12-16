import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:triviaapp/provider/theme_provider.dart';
import 'package:triviaapp/screens/game/game_screen.dart';
import 'package:triviaapp/screens/multiplayer/lobby_screen.dart';
import 'package:triviaapp/screens/game/difficulty_and_topic_screen.dart';
import 'package:triviaapp/data/sample_questions.dart';
import 'package:triviaapp/utils/difficulty_mapper.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivi App'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hola, ${user?.displayName ?? user?.email ?? 'Jugador'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Jugar Solo'),
              onPressed: () => _startSoloGame(context),
            ),

            const SizedBox(height: 20),

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

            const SizedBox(height: 20),

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
