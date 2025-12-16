import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:triviaapp/screens/multiplayer/game_room_screen.dart';
import 'package:triviaapp/services/room_service.dart';
import 'package:triviaapp/data/sample_questions.dart';
import 'package:triviaapp/utils/difficulty_mapper.dart';
import 'package:triviaapp/screens/game/difficulty_and_topic_screen.dart';
import 'package:triviaapp/models/difficulty.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final _roomService = RoomService();
  final _roomCodeController = TextEditingController();
  Difficulty _difficulty = Difficulty.medium;
  String _topic = "General"; // NUEVO
  bool _loading = false;

  Future<void> _startMultiplayer(BuildContext context) async {
    final config = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DifficultyAndTopicScreen(isMultiplayer: true),
      ),
    );

    if (config == null) return;

    setState(() {
      _difficulty = difficultyFromString(config['difficulty']);
      _topic = config['topic'];
    });
  }

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final difficultyEnum = difficultyFromString(widget.selectedDifficulty);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Debes iniciar sesión para jugar.")),
      );
    }

    final uid = user.uid;
    final name = user.displayName ?? "Jugador";

    return Scaffold(
      appBar: AppBar(title: const Text("Lobby Multijugador")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Text("Tema: ${widget.selectedTopic}"),
            // Text("Dificultad: ${widget.selectedDifficulty.toUpperCase()}"),

            // const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await _startMultiplayer(context);

                      setState(() => _loading = true);

                      final roomId = await _roomService.createRoom(
                        hostUid: uid,
                        hostName: name,
                        topic: _topic,
                        difficulty: _difficulty.toString(),
                        questions: sampleQuestions,
                      );

                      setState(() => _loading = false);

                      if (roomId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error al crear la sala"),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameRoomScreen(roomId: roomId),
                        ),
                      );
                    },
                    child: const Text("Crear Sala"),
                  ),

            const SizedBox(height: 30),

            TextField(
              controller: _roomCodeController,
              decoration: const InputDecoration(
                labelText: "Código de Sala",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final code = _roomCodeController.text.trim();
                if (code.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ingresa un código válido")),
                  );
                  return;
                }

                final ok = await _roomService.joinRoom(
                  roomCode: code,
                  uid: uid,
                  name: name,
                );

                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "No se pudo unir. Sala llena o ya iniciada.",
                      ),
                    ),
                  );
                  return;
                }

                final query = await FirebaseFirestore.instance
                    .collection('rooms')
                    .where('roomCode', isEqualTo: code)
                    .limit(1)
                    .get();

                final roomId = query.docs.first.id;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameRoomScreen(roomId: roomId),
                  ),
                );
              },
              child: const Text("Unirse"),
            ),
          ],
        ),
      ),
    );
  }
}
