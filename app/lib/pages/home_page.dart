import 'package:flutter/material.dart';
import '../widgets/speech.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            // Title
            Text(
              'Bienvenido Max',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 24),

            // Widget de Speech to Text
            Expanded(
              child: STTUWidget(),
            ),
          ],
        ),
      ),
    );
  }
}