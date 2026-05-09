import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'features/chat/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        '/chat': (context) => const ChatScreen(),
      },

      home: const SplashScreen(),
    );
  }
}

