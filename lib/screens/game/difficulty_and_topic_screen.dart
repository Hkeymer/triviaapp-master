import 'package:flutter/material.dart';

class DifficultyAndTopicScreen extends StatefulWidget {
  final bool isMultiplayer;

  const DifficultyAndTopicScreen({super.key, required this.isMultiplayer});

  @override
  State<DifficultyAndTopicScreen> createState() => _DifficultyAndTopicScreenState();
}

class _DifficultyAndTopicScreenState extends State<DifficultyAndTopicScreen> {
  String _selectedDifficulty = 'facil';
  final TextEditingController _topicController = TextEditingController();

  void _finish() {
    final topic = _topicController.text.trim();

    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes escribir un tema')),
      );
      return;
    }

    Navigator.pop(context, {
      'difficulty': _selectedDifficulty,
      'topic': topic,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isMultiplayer ? 'Configurar Multijugador' : 'Configurar Juego')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dificultad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            DropdownButton<String>(
              value: _selectedDifficulty,
              items: const [
                DropdownMenuItem(value: 'facil', child: Text('Fácil')),
                DropdownMenuItem(value: 'medio', child: Text('Medio')),
                DropdownMenuItem(value: 'dificil', child: Text('Difícil')),
              ],
              onChanged: (value) {
                setState(() => _selectedDifficulty = value!);
              },
            ),

            const SizedBox(height: 30),
            const Text('Tema', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            TextField(
              controller: _topicController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Escribe el tema del juego o sala',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finish,
                child: const Text('Continuar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
