import 'dart:async';
import 'package:flutter/material.dart';

import 'results_screen.dart';
import 'package:triviaapp/models/trivia_question.dart';
import 'package:triviaapp/widgets/game/timer_bar.dart';
import 'package:triviaapp/models/difficulty.dart';

class GameScreen extends StatefulWidget {
  final List<TriviaQuestion> questions;
  final bool autoShuffle;
  final bool readOnly;
  final Function(int finalScore)? onFinish;
  final Difficulty difficulty;
  final String topic; // NUEVO

  const GameScreen({
    super.key,
    required this.questions,
    this.autoShuffle = true,
    this.readOnly = false,
    this.onFinish,
    this.difficulty = Difficulty.medium,
    required this.topic, // NUEVO
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentIndex = 0;
  int score = 0;
  bool answerChecked = false;
  int? selectedAnswer;

  Timer? countdown;

  @override
  void initState() {
    super.initState();
    if (widget.autoShuffle) {
      widget.questions.shuffle();
    }
  }

  @override
  void dispose() {
    countdown?.cancel();
    super.dispose();
  }

  void autoNextQuestion() {
    if (!answerChecked) {
      answerChecked = true;
      selectedAnswer = null;
    }

    Future.delayed(const Duration(milliseconds: 700), () {
      goToNextQuestion();
    });
  }

  void checkAnswer(int selectedIndex) {
    if (answerChecked) return;

    setState(() {
      selectedAnswer = selectedIndex;
      answerChecked = true;
    });

    final q = widget.questions[currentIndex];

    if (selectedIndex == q.correctAnswerIndex && !widget.readOnly) {
      score++;
    }

    Future.delayed(const Duration(milliseconds: 700), () {
      goToNextQuestion();
    });
  }

  void goToNextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        answerChecked = false;
        selectedAnswer = null;
      });
    } else {
      finishGame();
    }
  }

  void finishGame() {
    if (widget.onFinish != null) {
      widget.onFinish!(score);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          score: score,
          totalQuestions: widget.questions.length,
        ),
      ),
    );
  }

  Color? getButtonColor(int index) {
    if (!answerChecked) return Theme.of(context).primaryColor;
    final q = widget.questions[currentIndex];

    if (index == q.correctAnswerIndex) return Colors.green;
    if (index == selectedAnswer) return Colors.red;
    return Colors.grey[400];
  }

  int getTimePerQuestion() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return 20;
      case Difficulty.medium:
        return 12;
      case Difficulty.hard:
        return 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Trivia - ${widget.topic}"), // NUEVO (opcional)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TimerBar(
              key: ValueKey(currentIndex),
              durationSeconds: getTimePerQuestion(),
              onTimeUp: autoNextQuestion,
            ),

            const SizedBox(height: 20),

            Text(
              "Pregunta ${currentIndex + 1} de ${widget.questions.length}",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 20),

            Text(q.question, style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 20),

            ...List.generate(q.options.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => checkAnswer(i),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getButtonColor(i),
                  ),
                  child: Text(q.options[i]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
