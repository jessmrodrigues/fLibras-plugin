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
      TextDisplayWidget(
        displayedText:
            'A beleza da natureza é indescritível. Suas paisagens deslumbrantes nos inspiram a cada dia.',
        id: 0,
        onTap: (text) => findTextById(0),
      ),
      TextDisplayWidget(
        displayedText:
            'Os rios fluem serenamente, trazendo vida a todas as criaturas que deles dependem.',
        id: 1,
        onTap: (text) => findTextById(1),
      ),
      TextDisplayWidget(
        displayedText:
            'As florestas são o pulmão do nosso planeta, produzindo oxigênio e abrigando uma incrível diversidade de vida.',
        id: 2,
        onTap: (text) => findTextById(2),
      ),
    ];
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
