import 'package:flutter/material.dart';
import '../services/daily_questionnaire_storage.dart';

class DailyQuestionnairePage extends StatefulWidget {
  const DailyQuestionnairePage({super.key});

  @override
  State<DailyQuestionnairePage> createState() =>
      _DailyQuestionnairePageState();
}

class _DailyQuestionnairePageState
    extends State<DailyQuestionnairePage> {
  String? selectedOption;

  final List<String> options = [
    'Very good',
    'Good',
    'Neutral',
    'Bad',
    'Very bad',
  ];

  Future<void> _submit() async {
    if (selectedOption == null) return;

    await DailyQuestionnaireStorage.markTodayAsCompleted();
    if (mounted) {
      Navigator.pop(context); // vuelve a Home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Questionnaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'How do you feel today?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: selectedOption,
              items: options
                  .map(
                    (o) => DropdownMenuItem(
                      value: o,
                      child: Text(o),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select one option',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}