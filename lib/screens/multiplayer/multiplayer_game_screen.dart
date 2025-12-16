import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:triviaapp/models/trivia_question.dart';
import 'package:triviaapp/screens/game/game_screen.dart';
import 'package:triviaapp/utils/difficulty_mapper.dart';

class MultiplayerGameScreen extends StatefulWidget {
  final String roomId;
  const MultiplayerGameScreen({super.key, required this.roomId});

  @override
  State<MultiplayerGameScreen> createState() => _MultiplayerGameScreenState();
}

class _MultiplayerGameScreenState extends State<MultiplayerGameScreen> {
  List<TriviaQuestion> questions = [];
  String difficultyStr = "";
  String topic = "";

  @override
  void initState() {
    super.initState();
    loadRoomData();
  }

  Future<void> loadRoomData() async {
    final snap = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .get();

    final data = snap.data()!;
    difficultyStr = data['difficulty'] ?? "medio";
    topic = data['topic'] ?? "General";

    questions = (data['questions'] as List)
        .map((q) => TriviaQuestion.fromMap(Map<String, dynamic>.from(q)))
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Modo Multijugador - $topic"),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          // Juego
          Expanded(
            child: GameScreen(
              questions: questions,
              autoShuffle: false,
              difficulty: difficultyFromString(difficultyStr),
              topic: topic, // <- AQUÍ se pasa topic
              onFinish: (finalScore) {
                // ejemplo: guardar puntaje por jugador (ajusta a tu esquema)
                FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(widget.roomId)
                    .collection('scores')
                    .add({
                      'uid': FirebaseFirestore.instance.app.options.projectId,
                      'score': finalScore,
                    });
                print("Jugador terminó con puntaje: $finalScore");
              },
            ),
          ),
        ],
      ),
    );
  }
}
