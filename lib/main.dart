import 'package:flutter/material.dart';
import 'flibras_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCC - fLibras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FLibrasView(),
    );
  }
}
