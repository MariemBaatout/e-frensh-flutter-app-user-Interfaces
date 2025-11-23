class Score {
  final String scoreId;
  final String email;
  final String correctAnswer;
  final String incorrectAnswer;
  final String score;
  final String responseTime;

  Score({
    required this.scoreId,
    required this.email,
    required this.correctAnswer,
    required this.incorrectAnswer,
    required this.score,
    required this.responseTime,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      scoreId: json['scoreId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? '',
      incorrectAnswer: json['incorrectAnswer'] as String? ?? '',
      score: json['score'] as String? ?? '',
      responseTime: json['responseTime'] as String? ?? '',
    );
  }
}
