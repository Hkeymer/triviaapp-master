import 'package:triviaapp/models/difficulty.dart';

Difficulty difficultyFromString(String value) {
  value = value.toLowerCase();

  switch (value) {
    case "easy":
    case "facil":
      return Difficulty.easy;

    case "medium":
    case "medio":
      return Difficulty.medium;

    case "hard":
    case "dificil":
      return Difficulty.hard;

    default:
      return Difficulty.medium;
  }
}
