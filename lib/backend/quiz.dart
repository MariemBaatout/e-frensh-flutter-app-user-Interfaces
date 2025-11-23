class Quiz {
  final String quizId;
  String title;
  String type; // 'easy', 'medium', 'hard'
  List<Question> questions;

  Quiz({
    required this.quizId,
    required this.title,
    required this.type,
    required this.questions,
  });

  // Factory method to create Quiz object from JSON (from API)
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizId: json['quizId'] as String? ?? '',
      title: json['title'],
      type: json['type'],
      questions: List<Question>.from(
          json['questions'].map((q) => Question.fromJson(q))),
    );
  }

  // Method to convert Quiz object to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'title': title,
      'type': type,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class Question {
  String questionText;
  List<Option> options;
  String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  // Factory method to create Question object from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'],
      options:
          List<Option>.from(json['options'].map((o) => Option.fromJson(o))),
      correctAnswer: json['correctAnswer'],
    );
  }

  // Method to convert Question object to JSON
  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'options': options.map((o) => o.toJson()).toList(),
      'correctAnswer': correctAnswer,
    };
  }
}

class Option {
  String optionText;
  bool isCorrect;

  Option({
    required this.optionText,
    this.isCorrect = false,
  });

  // Factory method to create Option object from JSON
  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionText: json['optionText'],
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  // Method to convert Option object to JSON
  Map<String, dynamic> toJson() {
    return {
      'optionText': optionText,
      'isCorrect': isCorrect,
    };
  }
}
