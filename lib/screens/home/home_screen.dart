import 'package:flutter/material.dart';

import 'package:triviaapp/screens/game/game_screen.dart';
import 'package:triviaapp/screens/game/difficulty_and_topic_screen.dart';
import 'package:triviaapp/data/sample_questions.dart';
import 'package:triviaapp/utils/difficulty_mapper.dart';
import 'package:triviaapp/widgets/game/countdown_24h.dart';
import 'package:triviaapp/widgets/game/trivia_topic_card.dart';
import 'package:triviaapp/widgets/layout/bottom_navigation_bar_menu.dart';
import 'package:triviaapp/models/menu_item_model.dart';

import 'package:triviaapp/screens/multiplayer/lobby_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController _topicController = TextEditingController();
  bool get isButtonEnabled => _topicController.text.trim().isNotEmpty;
  Future<void> _startSoloGame(BuildContext context) async {
    // final config = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const DifficultyAndTopicScreen(isMultiplayer: false),
    //   ),
    // );

    // if (config == null) return;

    // final difficulty = difficultyFromString(config['difficulty']);
    // final topic = config['topic'];

    final questions = sampleQuestions;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          questions: questions,
          autoShuffle: true,
          // difficulty: difficulty,
          topic: _topicController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('TRIVIAPP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _statsCard(context),
              const SizedBox(height: 16),
              _bottomMultiplayer(context),
              const SizedBox(height: 16),
              const Countdown24h(),
              const Text(
                'Tus vidas se recargan en las próximas 24h',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TriviaTopicCard(
                title: 'Tema de la Trivia',
                controller: _topicController,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () => _startSoloGame(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.videogame_asset, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'PLAY',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarMenu(
        items: [
          MenuItemModel(
            icon: Icons.gamepad,
            title: 'Trivia',
            color: Colors.red,
            onTap: () {},
          ),
          MenuItemModel(
            icon: Icons.leaderboard,
            title: 'Ranking',
            color: Colors.yellow,
            onTap: () {},
          ),
          MenuItemModel(
            icon: Icons.person,
            title: 'Perfil',
            color: Colors.green,
            onTap: () {},
          ),
        ],
      ),
    );
  }
  // ------------------ Widgets auxiliares ------------------

  Widget _statsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
        children: const [
          _StatRow(
            label: 'Vidas',
            icon: Icons.favorite,
            value: 'x 3',
            iconColor: Colors.red,
          ),
          SizedBox(height: 12),
          _StatRow(
            label: 'Puntuación',
            icon: Icons.paid,
            value: 'x 0',
            iconColor: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _livesInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Se estarán recargando tus vidas x3 en las próximas...',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Widget _bottomMultiplayer(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LobbyScreen()));
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.groups, size: 32, color: Colors.white),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Multijugador',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Juega con tus amigos en tiempo real',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ------------------ Widget reutilizable ------------------

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 4),
            Text(value),
          ],
        ),
      ],
    );
  }
}
