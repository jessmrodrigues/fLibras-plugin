import 'package:flutter/material.dart';

class TextDisplayWidget extends StatefulWidget {
  final String displayedText;
  final int id;
  final Function(int) onTap;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final double lineHeight;
  final String? fontFamily;
  final double letterSpacing;
  final double wordSpacing;
  final TextBaseline textBaseline;
  final TextDecoration textDecoration;

  const TextDisplayWidget({
    Key? key,
    required this.displayedText,
    required this.onTap,
    required this.id,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.blue,
    this.lineHeight = 1.0,
    this.fontFamily = 'Arial',
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
    this.textBaseline = TextBaseline.alphabetic,
    this.textDecoration = TextDecoration.none,
  }) : super(key: key);

  @override
  _TextDisplayWidgetState createState() => _TextDisplayWidgetState();
}

class _TextDisplayWidgetState extends State<TextDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.id);
      },
      child: Text(
        widget.displayedText,
        style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.textColor),
      ),
    );
  }
}
