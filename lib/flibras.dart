import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:test_singleton/webview_controller_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'html_content.dart';

class fLibras extends StatelessWidget {
  final List<String> texts;
  HtmlGenerator htmlGenerator = HtmlGenerator();

  fLibras({required this.texts});

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
      height: 500,
      width: 500,
      child: WebView(
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
      ),
    );
  }
}
