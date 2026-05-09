import 'package:flutter/material.dart';

class PrimaryLongButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryLongButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),

        child: Text(text),
      ),
    );
  }
}
