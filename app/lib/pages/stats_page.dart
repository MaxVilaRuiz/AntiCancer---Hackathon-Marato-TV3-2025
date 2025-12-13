import 'package:flutter/material.dart';
import '../services/daily_questionnaire_storage.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  static const int requiredDays = 7;

  // Videos + recomendaciones (pon aquí los definitivos cuando los tengas)
  static const Map<String, List<String>> videosByDiagnosis = {
    'Atenció': [
      'https://example.com/video/attention-1',
      'https://example.com/video/attention-2',
    ],
    'Memòria': [
      'https://example.com/video/memory-1',
      'https://example.com/video/memory-2',
    ],
    'Velocitat de processament': [
      'https://example.com/video/processing-1',
      'https://example.com/video/processing-2',
    ],
    'Fluència verbal': [
      'https://example.com/video/fluency-1',
      'https://example.com/video/fluency-2',
    ],
    'Cap': [
      'https://example.com/video/maintenance-1',
    ],
  };

  static const Map<String, String> recommendationByDiagnosis = {
    'Atenció':
        'Recomanació: redueix distraccions (notificacions), treballa en blocs de 10–20 min i fes pauses curtes.',
    'Memòria':
        'Recomanació: fes servir pistes (notes breus), repetició espaiada i rutines estables (mateix lloc per a objectes).',
    'Velocitat de processament':
        'Recomanació: baixa ritme, una tasca a la vegada, evita multitasking i dorm/descansa adequadament.',
    'Fluència verbal':
        'Recomanació: practica recuperació de paraules (categories, sinònims), parla en veu alta i fes lectura guiada.',
    'Cap':
        'Recomanació: mantén hàbits saludables (son, activitat física suau, hidratació) i continua registrant 7 dies seguits.',
  };

  // Los diagnósticos que quieres mostrar (y su orden base si empatan)
  static const List<String> trackedDiagnoses = [
    'Atenció',
    'Memòria',
    'Velocitat de processament',
    'Fluència verbal',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DailyQuestionnaireStorage.getLast7DaysEntries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = snapshot.data ?? [];
        if (entries.length < requiredDays) {
          final missing = requiredDays - entries.length;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Encara no hi ha prou dades.\nFalten $missing dies per omplir formularis.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        // Contar diagnósticos en los últimos 7 días
        final counts = <String, int>{};
        for (final e in entries) {
          final diag = (e['diagnosis'] as String?) ?? 'Cap';
          counts[diag] = (counts[diag] ?? 0) + 1;
        }

        // Si todos son "Cap" => bloque "Sin problemas"
        final allNoProblem = entries.every((e) => (e['diagnosis'] as String?) == 'Cap');

        // Diagnósticos detectados (de los 4 que te interesan), ordenados por frecuencia desc
        final detected = trackedDiagnoses
            .where((d) => (counts[d] ?? 0) > 0)
            .toList()
          ..sort((a, b) {
            final cb = counts[b] ?? 0;
            final ca = counts[a] ?? 0;
            if (cb != ca) return cb.compareTo(ca);
            // empate -> respeta el orden base
            return trackedDiagnoses.indexOf(a).compareTo(trackedDiagnoses.indexOf(b));
          });

        // Bloques a mostrar
        final blocks = <Widget>[];

        // 1) Bloque problemas cognitivos (no se usa de momento)
        blocks.add(_InfoBlock(
          title: 'Problemes cognitius (no actiu)',
          subtitle: 'Aquest bloc no s’està utilitzant de moment.',
          recommendation:
              'Quan s’integri la part objectiva, aquí es mostraran resultats i recomanacions específiques.',
          urls: const [],
        ));

        // 2) Bloque sin problemas (si aplica)
        if (allNoProblem || detected.isEmpty) {
          blocks.add(_InfoBlock(
            title: 'No s’han detectat problemes',
            subtitle: 'Els últims 7 dies no indiquen dificultats subjectives destacades.',
            recommendation: recommendationByDiagnosis['Cap']!,
            urls: videosByDiagnosis['Cap']!,
          ));
        }

        // 3) Bloques de diagnósticos detectados (en orden)
        for (final diag in detected) {
          blocks.add(_InfoBlock(
            title: diag,
            subtitle:
                'Detectat ${counts[diag]} de $requiredDays dies.',
            recommendation: recommendationByDiagnosis[diag] ?? 'Recomanació: mantén un pla d’entrenament breu i constant.',
            urls: videosByDiagnosis[diag] ?? const [],
          ));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Stats (últims 7 dies)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...blocks.map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: w,
                )),
          ],
        );
      },
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final String recommendation;
  final List<String> urls;

  const _InfoBlock({
    required this.title,
    required this.subtitle,
    required this.recommendation,
    required this.urls,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 12),
            Text(recommendation, style: const TextStyle(fontSize: 14)),
            if (urls.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Vídeos recomanats:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              ...urls.map(
                (u) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    u,
                    style: const TextStyle(
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}