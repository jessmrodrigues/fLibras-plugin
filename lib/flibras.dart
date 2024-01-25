import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_singleton/webview_controller_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'html_content.dart';

class FLibras extends StatelessWidget {
  final List<String> texts;
  final HtmlGenerator htmlGenerator = HtmlGenerator();

  FLibras({super.key, required this.texts});

  String _generateHtmlContent() {
    return htmlGenerator.generateHtmlContent();
  }

  void _injectTextIntoWebView(WebViewController controller) async {
    final script = "setTextFromFlutter(${json.encode(texts)});";
    controller.runJavascript(script);
  }

  @override
  Widget build(BuildContext context) {
    final htmlContent = _generateHtmlContent();
    return SizedBox(
      height: 150,
      width: 150,
      child: WebView(
        backgroundColor: Colors.transparent,
        initialUrl: Uri.dataFromString(
          htmlContent,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          WebViewControllerManager().setWebViewController(controller);
        },
        onPageFinished: (url) {
          _injectTextIntoWebView(WebViewControllerManager().webViewController!);
        },
        gestureNavigationEnabled: false,
      ),
    );
  }
}
