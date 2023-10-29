import 'package:flutter/material.dart';

class TextDisplayWidget extends StatelessWidget {
  final String displayedText;
  final int id;
  final Function(int) onTap;

  const TextDisplayWidget(
      {super.key,
      required this.displayedText,
      required this.onTap,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(id);
      },
      child: Text(
        displayedText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}
