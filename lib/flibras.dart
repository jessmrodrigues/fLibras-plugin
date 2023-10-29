import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:test_singleton/webview_controller_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class fLibras extends StatelessWidget {
  final List<String> texts;

  fLibras({required this.texts});

  final String htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
      <title>VLibras</title>
    </head>
    <body>
      <div vw class="enabled">
        <div vw-access-button class="active"></div>
        <div vw-plugin-wrapper>
          <div class="vw-plugin-top-wrapper"></div>
        </div>
      </div>
      <script src="https://vlibras.gov.br/app/vlibras-plugin.js"></script>
      <script>
        new window.VLibras.Widget('https://vlibras.gov.br/app');
      </script>
      <p id="texto"></p>
      <script>
        function setTextFromFlutter(textArray) {
          var textoElement = document.getElementById('texto');
          textoElement.innerHTML = "";

          for (var i = 0; i < textArray.length; i++) {
            var paragraph = document.createElement('p');
            paragraph.innerText = textArray[i];
            paragraph.id = i;
            textoElement.appendChild(paragraph);
          }
        }
        function fLibrasClick(id) {
          var t = document.getElementById(id);
          t.click();
        }
      </script>
    </body>
    </html>
  ''';

  void _injectTextIntoWebView(WebViewController controller) async {
    final script = "setTextFromFlutter(${json.encode(texts)});";
    controller.runJavascript(script);
  }

  @override
  Widget build(BuildContext context) {
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
