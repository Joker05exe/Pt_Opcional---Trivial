import 'package:html_unescape/html_unescape.dart';

class Question {
  final String type;
  final String difficulty;
  final String category;
  final String questionText;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  
  // Llista barrejada (correcta + incorrectes) per mostrar a la UI
  late final List<String> allAnswers;

  Question({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.questionText,
    required this.correctAnswer,
    required this.incorrectAnswers,
  }) {
    // Barregem les respostes al crear l'objecte
    var unescape = HtmlUnescape();
    
    // Creem la llista completa i la barregem
    List<String> answers = List.from(incorrectAnswers);
    answers.add(correctAnswer);
    answers.shuffle();
    
    // Descodifiquem HTML de les opcions barrejades
    allAnswers = answers.map((a) => unescape.convert(a)).toList();
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();

    return Question(
      type: json['tipus'] ?? '',
      difficulty: json['dificultat'] ?? '',
      category: unescape.convert(json['categoria'] ?? 'General'),
      questionText: unescape.convert(json['pregunta'] ?? ''),
      correctAnswer: json['resposta_correcta'] ?? '', // Es descodifica visualment després per comparar lògica
      incorrectAnswers: List<String>.from(json['respostes_incorrectes'] ?? []),
    );
  }
}