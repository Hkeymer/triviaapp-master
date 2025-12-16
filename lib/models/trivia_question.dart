class TriviaQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory TriviaQuestion.fromMap(Map<String, dynamic> map) {
    return TriviaQuestion(
      question: map['question'],
      options: List<String>.from(map['options']),
      correctAnswerIndex: map['correctAnswerIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}

