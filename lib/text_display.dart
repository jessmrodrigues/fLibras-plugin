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

  TextDisplayWidget({
    required this.displayedText,
    required this.onTap,
    required this.id,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.blue,
    this.lineHeight = 1.0,
    this.fontFamily = 'Helvetica',
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
    this.textBaseline = TextBaseline.alphabetic,
    this.textDecoration = TextDecoration.none,
  });

  @override
  _TextDisplayWidgetState createState() => _TextDisplayWidgetState();
}

class _TextDisplayWidgetState extends State<TextDisplayWidget> {
  int? lastClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (lastClicked == widget.id) {
            lastClicked = null;
          } else {
            lastClicked = widget.id;
          }
        });
        widget.onTap(widget.id);
      },
      child: Text(
        widget.displayedText,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          color: widget.textColor,
          decoration: lastClicked == widget.id
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );
  }
}
