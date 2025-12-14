import 'package:flutter/material.dart';
import '../widgets/domain_button.dart';
import 'domains/domain1_page.dart';
import 'domains/domain2_page.dart';
import 'domains/domain3_page.dart';
import 'domains/domain4_page.dart';

class BrainPage extends StatelessWidget {
  const BrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Title
            const Text(
              'Mesures Objectives',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Selecciona una test per començar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 32),

            // Grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemHeight =
                      (constraints.maxHeight - 16) / 2;
                  final itemWidth =
                      (constraints.maxWidth - 16) / 2;

                  final aspectRatio = itemWidth / itemHeight;

                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: aspectRatio,
                    children: [
                      DomainButton(
                        title: "Fluència Verbal Alternant",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Domain1Page(),
                            ),
                          );
                        },
                      ),
                      DomainButton(
                        title: "Atenció",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Domain2Page(),
                            ),
                          );
                        },
                      ),
                      DomainButton(
                        title: 'Memòria',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Domain3Page(),
                            ),
                          );
                        },
                      ),
                      DomainButton(
                        title: 'Velocitat del Processament',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Domain4Page(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}