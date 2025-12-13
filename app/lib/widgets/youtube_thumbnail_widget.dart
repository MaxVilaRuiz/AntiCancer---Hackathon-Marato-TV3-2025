import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String? extractYoutubeId(String url) {
  final regExp = RegExp(
    r'(?:v=|\/)([0-9A-Za-z_-]{11}).*',
    caseSensitive: false,
  );
  final match = regExp.firstMatch(url);
  return match?.group(1);
}

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class YoutubeThumbnail extends StatelessWidget {
  final String url;

  const YoutubeThumbnail({super.key, required this.url});

  static const double _maxWidth = 420;

  @override
  Widget build(BuildContext context) {
    final videoId = extractYoutubeId(url);
    if (videoId == null) return const SizedBox.shrink();

    final thumbnailUrl =
        'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: _maxWidth,
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: InkWell(
            onTap: () => openUrl(url),
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    thumbnailUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}