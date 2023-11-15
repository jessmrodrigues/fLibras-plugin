import 'package:flutter/material.dart';
import 'package:test_singleton/text_display.dart';
import 'package:test_singleton/webview_controller_manager.dart';

import 'flibras.dart';

class FLibrasView extends StatefulWidget {
  @override
  _FLibrasViewState createState() => _FLibrasViewState();
}

class _FLibrasViewState extends State<FLibrasView> {
  List<String> listTexts = [];

  @override
  Widget build(BuildContext context) {
    final List<TextDisplayWidget> textWidgets = [
      'A beleza da natureza é indescritível. Suas paisagens deslumbrantes nos inspiram a cada dia.',
      'Os rios fluem serenamente, trazendo vida a todas as criaturas que deles dependem.',
      'As florestas são o pulmão do nosso planeta, produzindo oxigênio e abrigando uma incrível diversidade de vida.',
    ].asMap().entries.map((entry) {
      final int id = entry.key;
      final String text = entry.value;
      return TextDisplayWidget(
        displayedText: text,
        id: id,
        onTap: (text) => findTextById(id),
        fontSize: 20,
        fontWeight: FontWeight.normal,
        textColor: Colors.blue,
      );
    }).toList();
    listTexts = textWidgets.map((widget) => widget.displayedText).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('A Maravilha da Natureza'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var widget in textWidgets) Center(child: widget),
            fLibras(texts: listTexts),
          ],
        ),
      ),
    );
  }

  void findTextById(int id) {
    final webViewController = WebViewControllerManager().webViewController;
    if (webViewController != null) {
      webViewController.runJavascript('fLibrasClick($id);');
    }
  }
}
