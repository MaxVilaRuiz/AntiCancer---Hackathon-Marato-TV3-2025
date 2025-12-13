import 'package:flutter/material.dart';
import 'package:speech_to_text_ultra/speech_to_text_ultra.dart';

class STTUWidget extends StatefulWidget {
  final Function(bool)? onListeningChanged;
  final Function(List<String>)? onWordsUpdated;

  const STTUWidget({
    super.key,
    this.onListeningChanged,
    this.onWordsUpdated,
  });

  @override
  State<STTUWidget> createState() => STTUState();
}

class STTUState extends State<STTUWidget> {
  bool mIsListening = false;
  String mResponse = '';
  String mLiveResponse = '';
  List<String> mWords = [];

  // Normalization Map
  static const Map<String, String> _numberMap = {
    // Spanish
    'uno': '1',
    'dos': '2',
    'tres': '3',
    'cuatro': '4',
    'cinco': '5',
    'seis': '6',
    'siete': '7',
    'ocho': '8',
    'nueve': '9',

    // Catalan
    'un': '1',
    'quatre': '4',
    'cinc': '5',
    'sis': '6',
    'set': '7',
    'vuit': '8',
    'nou': '9',

    // English
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
  };

  /// Normalize number words into digits
  List<String> _normalizeWords(String text) {
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove signs
        .split(RegExp(r'\s+'));

    return words.map((word) {
      // Convert if is a number in word
      if (_numberMap.containsKey(word)) {
        return _numberMap[word]!;
      }

      // Ignore if is a valid number (digits)
      if (RegExp(r'^[1-9]$').hasMatch(word)) {
        return word;
      }

      return '';
    }).where((w) => w.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mIsListening ? '$mResponse $mLiveResponse' : mResponse,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SpeechToTextUltra(
            ultraCallback:
                (String liveText, String finalText, bool isListening) {
              setState(() {
                mLiveResponse = liveText;
                mResponse = finalText;
                mIsListening = isListening;

                widget.onListeningChanged?.call(mIsListening);

                // Normalize
                mWords = _normalizeWords(mLiveResponse);
                widget.onWordsUpdated?.call(mWords);
              });
            },
          ),
        ],
      ),
    );
  }
}