import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/speech.dart';

class Domain3Page extends StatefulWidget {
  const Domain3Page({super.key});

  @override
  State<Domain3Page> createState() => _Domain3PageState();
}

class _Domain3PageState extends State<Domain3Page> {
  // Configuración del test
  static const int totalPhases = 5;
  static const int repetitionsPerPhase = 2;

  int currentPhase = 0;
  int currentRepetition = 0;

  bool showInstructions = true;
  bool showInput = false;
  bool testFinished = false;

  List<int> currentNumbers = [];
  List<int> phaseFailures = [];

  final TextEditingController controller = TextEditingController();
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    phaseFailures = List.filled(totalPhases, 0);
  }

  // ---------------- LOGIC ----------------

  void _startTest() {
    _generateNumbers();
    setState(() {
      showInstructions = false;
    });
  }

  void _generateNumbers() {
    int digits = currentPhase + 4; // 4 a 9
    currentNumbers =
        List.generate(digits, (_) => random.nextInt(9) + 1);
  }

  void _startRepetition() {
    setState(() {
      showInput = true;
    });
  }

  void _nextStep() {
    // 🔁 Secuencia correcta en orden inverso
    final expected =
        currentNumbers.reversed.join('');

    final input =
        controller.text.replaceAll(' ', '');

    if (input != expected) {
      phaseFailures[currentPhase]++;
    }

    controller.clear();
    showInput = false;

    // ❌ Si falla dos veces la fase → termina
    if (phaseFailures[currentPhase] == repetitionsPerPhase) {
      setState(() {
        testFinished = true;
      });
      return;
    }

    // ➡️ Pasar a siguiente repetición o fase
    if (currentRepetition < repetitionsPerPhase - 1) {
      currentRepetition++;
      _generateNumbers();
    } else {
      currentPhase++;
      currentRepetition = 0;

      if (currentPhase == totalPhases) {
        testFinished = true;
        setState(() {});
        return;
      }

      _generateNumbers();
    }

    setState(() {});
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain 1 – Reverse Memory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: showInstructions
            ? _buildInstructions()
            : testFinished
                ? _buildResults()
                : showInput
                    ? _buildInputPhase()
                    : _buildShowNumbersPhase(),
      ),
    );
  }

  // ---------------- SCREENS ----------------

  Widget _buildInstructions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Reverse Digit Memory Test',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        const Text(
          'You will see sequences of numbers.\n\n'
          'Your task is to repeat the numbers\n'
          'IN REVERSE ORDER.\n\n'
          'Each phase has two attempts.\n'
          'If you fail both attempts in the same phase,\n'
          'the test will end.\n\n'
          'Try to be as accurate as possible.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _startTest,
          child: const Text('Start Test'),
        ),
      ],
    );
  }

  Widget _buildShowNumbersPhase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Phase ${currentPhase + 1} '
          '(Attempt ${currentRepetition + 1}/$repetitionsPerPhase)',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: currentNumbers
              .map(
                (n) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    n.toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _startRepetition,
          child: const Text('Enter in reverse'),
        ),
      ],
    );
  }

  Widget _buildInputPhase() {
    return Column(
      children: [
        Text(
          'Phase ${currentPhase + 1} '
          '(Attempt ${currentRepetition + 1}/$repetitionsPerPhase)',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter the numbers in reverse order',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        STTUWidget(),
        const Spacer(),
        ElevatedButton(
          onPressed: _nextStep,
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final failedPhases =
        phaseFailures.where((f) => f == repetitionsPerPhase).length;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Results',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            'Failed phases: $failedPhases / $totalPhases',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}