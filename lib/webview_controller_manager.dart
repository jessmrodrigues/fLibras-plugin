import 'package:webview_flutter/webview_flutter.dart';

class WebViewControllerManager {
  static final WebViewControllerManager _instance = WebViewControllerManager._internal();
  late WebViewController? webViewController;

  factory WebViewControllerManager() {
    return _instance;
  }

  WebViewControllerManager._internal();

  void setWebViewController(WebViewController controller) {
    webViewController = controller;
  }
}
