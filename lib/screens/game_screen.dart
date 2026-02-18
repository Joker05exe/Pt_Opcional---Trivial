import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import '../models/question.dart';
import '../utils/category_colors.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Estat de la càrrega
  bool isLoading = true;
  bool hasError = false;
  
  // Dades del joc
  List<Question> questions = [];
  int currentIndex = 0;
  int score = 0;
  
  // Estat de la pregunta actual
  bool isAnswered = false;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  // 3.1 Càrrega remota
  Future<void> fetchQuestions() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final url = Uri.parse('https://www.vidalibarraquer.net/android/trivial.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> list = data['Trivial'];

        setState(() {
          questions = list.map((json) => Question.fromJson(json)).toList();
          isLoading = false;
          // Reiniciem variables de joc
          currentIndex = 0;
          score = 0;
          isAnswered = false;
          selectedAnswer = null;
        });
      } else {
        throw Exception('Error al servidor');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  // 3.4 i 3.5 Lògica de resposta
  void checkAnswer(String answer) {
    if (isAnswered) return; // Evitar múltiples clics

    var unescape = HtmlUnescape();
    // Necessitem comparar amb la resposta descodificada perquè la llista mostrada ja ho està
    String correctDecoded = unescape.convert(questions[currentIndex].correctAnswer);
    
    bool isCorrect = (answer == correctDecoded);

    setState(() {
      isAnswered = true;
      selectedAnswer = answer;
      if (isCorrect) {
        score += 10;
      } else {
        score -= 5;
      }
    });
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        isAnswered = false;
        selectedAnswer = null;
      });
    } else {
      // Final del joc
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: score, totalQuestions: questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error carregant les preguntes.', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchQuestions,
                child: const Text('Reintenta'),
              ),
            ],
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: Text("No s'han trobat preguntes")));
    }

    final currentQuestion = questions[currentIndex];
    final categoryColor = CategoryColors.getColor(currentQuestion.category);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregunta ${currentIndex + 1} / ${questions.length}'),
        backgroundColor: categoryColor,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Punts: $score',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 3.6 Categoria amb Color
            Chip(
              backgroundColor: categoryColor.withOpacity(0.2),
              avatar: Icon(Icons.category, color: categoryColor),
              label: Text(
                currentQuestion.category,
                style: TextStyle(color: categoryColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Dificultat: ${currentQuestion.difficulty}",
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Pregunta
            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            // Llistat de respostes
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.allAnswers.length,
                itemBuilder: (context, index) {
                  final answer = currentQuestion.allAnswers[index];
                  return _buildAnswerButton(answer, currentQuestion);
                },
              ),
            ),
            // Botó següent (només visible si s'ha respost)
            if (isAnswered)
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: categoryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    currentIndex == questions.length - 1 ? 'Finalitzar' : 'Següent Pregunta',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String answer, Question question) {
    Color buttonColor = Colors.white;
    Color textColor = Colors.black87;
    var unescape = HtmlUnescape();
    String correctDecoded = unescape.convert(question.correctAnswer);

    // Feedback visual
    if (isAnswered) {
      if (answer == correctDecoded) {
        buttonColor = Colors.green.shade100; // La correcta sempre verda al final
        textColor = Colors.green.shade900;
      } else if (answer == selectedAnswer) {
        buttonColor = Colors.red.shade100; // Si l'has seleccionat i és incorrecta
        textColor = Colors.red.shade900;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: () => checkAnswer(answer),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(
              color: isAnswered && (answer == correctDecoded || answer == selectedAnswer) 
                  ? textColor 
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  answer,
                  style: TextStyle(
                    fontSize: 16, 
                    color: textColor,
                    fontWeight: isAnswered && answer == correctDecoded ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isAnswered && answer == correctDecoded)
                const Icon(Icons.check_circle, color: Colors.green),
              if (isAnswered && answer == selectedAnswer && answer != correctDecoded)
                const Icon(Icons.cancel, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}