import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Domain4Page extends StatefulWidget {
  const Domain4Page({super.key});

  @override
  State<Domain4Page> createState() => _Domain4PageState();
}

class ButtonNum {
  final int value;
  bool active;
  bool redBorder = false;
  bool greenBorder = false;

  ButtonNum(this.value, {this.active = true});
}

class _Domain4PageState extends State<Domain4Page> {
  // Timer
  Timer? timer;
  int milliseconds = 0;
  bool running = false;

  // UI states
  bool loading = true;
  bool showInstructions = true;
  bool showGrid = false;
  bool showEndScreen = false;

  // Stored result
  int? storedTimeMs;

  // Game state
  List<List<int>> matrix = List.generate(4, (_) => List.filled(5, 0));
  List<ButtonNum> buttons = [];
  final Random random = Random();
  int buttonAct = 0;

  @override
  void initState() {
    super.initState();
    _checkStoredResult();
  }

  // ---------------- STORAGE ----------------

  Future<void> _checkStoredResult() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('domain4');

    if (stored != null) {
      final data = jsonDecode(stored);
      storedTimeMs = data['timeMs'] as int;

      setState(() {
        showInstructions = false;
        showEndScreen = true;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode({
      'timeMs': milliseconds,
    });

    await prefs.setString('domain4', data);
  }

  // ---------------- GAME LOGIC ----------------

  void _startTest() {
    setState(() {
      showInstructions = false;
      showGrid = true;
      showEndScreen = false;
      buttonAct = 0;
      milliseconds = 0;
    });

    clearMatrix();
    positionNumbers();
    startTimer();
  }

  void clearMatrix() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 5; j++) {
        matrix[i][j] = 0;
      }
    }
    buttons.clear();
  }

  void positionNumbers() {
    Set<int> usedIndices = {};
    for (int i = 1; i <= 10; i++) {
      int r;
      do {
        r = random.nextInt(20);
      } while (usedIndices.contains(r));
      usedIndices.add(r);
      matrix[r ~/ 5][r % 5] = i;
      buttons.add(ButtonNum(i));
    }
  }

  void startTimer() {
    if (running) return;

    running = true;
    timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        milliseconds += 200;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    running = false;
  }

  int resultButton(ButtonNum btn) {
    if (btn.value == buttonAct + 1) {
      if (btn.value == 10) return 2;
      return 1;
    }
    return -1;
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Test de velocitat')),
      body: showInstructions
          ? _buildInstructions()
          : showEndScreen
              ? _buildEndScreen()
              : _buildGrid(),
    );
  }

  // -------- Instructions --------

  Widget _buildInstructions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Instruccions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'En aquesta prova veuràs una sèrie de números a la pantalla.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Hauràs de prémer els números en ordre, tan ràpid com puguis.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'El temps començarà a comptar quan iniciïs la prova.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fes-ho amb calma i concentra’t.\n'
              'No passa res si t’equivoques.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: 260,
              child: ElevatedButton(
                onPressed: _startTest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Començar la prova',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------- End screen --------

  Widget _buildEndScreen() {
    final time = storedTimeMs ?? milliseconds;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Has acabat!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Temps: ${(time / 1000).toStringAsFixed(2)} s',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  // -------- Grid --------

  Widget _buildGrid() {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / (size.height * 0.7);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: aspectRatio,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          final row = index ~/ 5;
          final col = index % 5;
          final value = matrix[row][col];

          if (value == 0) {
            return Container(color: Colors.grey[200]);
          }

          final btn = buttons.firstWhere((b) => b.value == value);

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  btn.active ? Colors.white : Colors.grey[700],
              side: BorderSide(
                color: btn.redBorder
                    ? Colors.red
                    : btn.greenBorder
                        ? Colors.green
                        : Colors.blue,
                width: 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: btn.active
                ? () {
                    setState(() {
                      final result = resultButton(btn);
                      if (result == 1) {
                        btn.active = false;
                        btn.greenBorder = true;
                        buttonAct++;
                      } else if (result == 2) {
                        btn.active = false;
                        btn.greenBorder = true;
                        stopTimer();
                        _saveResult();
                        showGrid = false;
                        showEndScreen = true;
                      } else {
                        btn.redBorder = true;
                      }
                    });

                    if (btn.redBorder) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        setState(() {
                          btn.redBorder = false;
                        });
                      });
                    }
                  }
                : null,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${btn.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}