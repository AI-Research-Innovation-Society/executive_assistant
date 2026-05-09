import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

MarkdownStyleSheet chatMarkdownStyle() {
  return MarkdownStyleSheet(
    p: const TextStyle(color: Colors.white, fontSize: 15, height: 1.6),
    h1: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    h2: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    h3: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
    listBullet: const TextStyle(color: Colors.white, fontSize: 15),
    strong: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    em: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
    code: const TextStyle(color: Color(0xFF89D4CF), fontSize: 14, fontFamily: 'monospace'),
    codeblockDecoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(8),
    ),
    codeblockPadding: const EdgeInsets.all(12),
    blockquoteDecoration: BoxDecoration(
      border: Border(left: BorderSide(color: Colors.white24, width: 3)),
    ),
    blockquotePadding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(top: BorderSide(color: Colors.white12, width: 1)),
    ),
  );
}
