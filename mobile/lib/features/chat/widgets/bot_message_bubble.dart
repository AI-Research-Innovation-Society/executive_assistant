import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../shared/styles/markdown_style.dart';
import '../../../shared/utils/tts_helper.dart';

class BotMessageBubble extends StatelessWidget {
  final String content;
  final int index;
  final int? speakingIndex;
  final FlutterTts flutterTts;
  final VoidCallback onTtsStop;
  final ValueChanged<int> onTtsStart;

  const BotMessageBubble({
    super.key,
    required this.content,
    required this.index,
    required this.speakingIndex,
    required this.flutterTts,
    required this.onTtsStop,
    required this.onTtsStart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: content,
            selectable: true,
            styleSheet: chatMarkdownStyle(),
          ),
          const SizedBox(height: 8),
          // Action buttons row
          Row(
            children: [
              // Copy
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white38, size: 18),
                tooltip: 'Copy',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
                  );
                },
              ),
              // Share
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white38, size: 18),
                tooltip: 'Share',
                onPressed: () {
                  Share.share(content);
                },
              ),
              // Add to Vault
              IconButton(
                icon: const Icon(Icons.lock_outline, color: Colors.white38, size: 18),
                tooltip: 'Add to Vault',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to Vault'), duration: Duration(seconds: 1)),
                  );
                },
              ),
              // Speaker (TTS) with controls
              if (speakingIndex == index) ...[
                // Stop button
                IconButton(
                  icon: const Icon(Icons.stop, color: Colors.redAccent, size: 18),
                  tooltip: 'Stop',
                  onPressed: () async {
                    await flutterTts.stop();
                    onTtsStop();
                  },
                ),
                // Replay button
                IconButton(
                  icon: const Icon(Icons.replay, color: Colors.white38, size: 18),
                  tooltip: 'Replay',
                  onPressed: () async {
                    await flutterTts.stop();
                    await flutterTts.speak(TtsHelper.stripMarkdownForTts(content));
                  },
                ),
              ] else
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.white38, size: 18),
                  tooltip: 'Read aloud',
                  onPressed: () async {
                    await flutterTts.stop();
                    onTtsStart(index);
                    await flutterTts.speak(TtsHelper.stripMarkdownForTts(content));
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
