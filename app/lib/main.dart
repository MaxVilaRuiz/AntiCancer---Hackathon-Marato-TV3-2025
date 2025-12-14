import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/main_scaffold.dart';

Future<void> main() async {
  // TODO: Delete this part to not initialize with predefined questionnaires (only for testing)
  WidgetsFlutterBinding.ensureInitialized();

  final predefinedQuestionnaires = [
    '{"date":"2025-12-13","diagnosis":"Atenció"}',
    '{"date":"2025-12-12","diagnosis":"Fluència verbal"}',
    '{"date":"2025-12-11","diagnosis":"Velocitat de processament"}',
    '{"date":"2025-12-10","diagnosis":"Memòria"}',
    '{"date":"2025-12-09","diagnosis":"Velocitat de processament"}',
    '{"date":"2025-12-08","diagnosis":"Fluència verbal"}',
  ];

  final prefs = await SharedPreferences.getInstance();

  // Only store if they do not exist
  if (!prefs.containsKey('daily_entries')) {
    await prefs.setStringList('daily_entries', predefinedQuestionnaires);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anticancer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainScaffold(),
    );
  }
}