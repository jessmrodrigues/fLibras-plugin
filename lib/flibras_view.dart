import 'package:flutter/material.dart';
import 'package:test_singleton/text_display.dart';
import 'package:url_launcher/url_launcher.dart';
import 'client/article.dart';
import 'flibras.dart';
import 'webview_controller_manager.dart';

class FLibrasView extends StatefulWidget {
  final Article article;

  const FLibrasView({Key? key, required this.article}) : super(key: key);

  @override
  _FLibrasViewState createState() => _FLibrasViewState();
}

class _FLibrasViewState extends State<FLibrasView> {
  late List<String> contentList;
  bool isImageUrlValid = true;
  late String title;

  @override
  void initState() {
    super.initState();
    title = widget.article.title;
    contentList = _prepareContentList();
    _checkImageUrlValidity(widget.article.imageUrl);
  }

  List<String> _prepareContentList() {
    List<String> preparedList = [];

    String author = widget.article.author;
    String pubdate = widget.article.pubdate ?? 'Data Desconhecida';
    String description = widget.article.description ?? '';
    String link = widget.article.link ?? 'Fonte Desconhecida';
    List<String> sentences =
        description.split(RegExp(r'(?<=\. )|(?<=\.)')).toList();

    preparedList.add('$author - $pubdate');
    preparedList.add('');
    preparedList.add(title);
    preparedList.addAll(sentences);
    preparedList.add('');
    preparedList.add('Leia na íntegra:');
    preparedList.add(link);
    return preparedList;
  }

  void _checkImageUrlValidity(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      Image.network(imageUrl)
          .image
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener(
              (info, synchronousCall) {
                setState(() {
                  isImageUrlValid = true;
                });
              },
              onError: (dynamic exception, StackTrace? stackTrace) {
                setState(() {
                  isImageUrlValid = false;
                });
              },
            ),
          );
    } else {
      setState(() {
        isImageUrlValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TextDisplayWidget(
            displayedText: title,
            id: contentList.indexOf(title),
            onTap: (id) {
              findTextById(id);
            },
            fontSize: 18.0,
            textColor: _getTitleColor(),
            textDecoration: TextDecoration.none,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isImageUrlValid && widget.article.imageUrl != null)
                    Image.network(
                      widget.article.imageUrl!,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: contentList
                          .asMap()
                          .entries
                          .map((entry) => TextDisplayWidget(
                                displayedText: entry.value,
                                id: entry.key,
                                onTap: (id) {
                                  if (entry.value.contains('https')) {
                                    launchUrl(Uri.parse(widget.article.link!));
                                  } else {
                                    findTextById(id);
                                  }
                                },
                                fontSize: 16.0,
                                textColor: _getTextColor(entry.value),
                                textDecoration: _getTextDecoration(entry.value),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              width: 400,
              child: Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FLibras(texts: contentList),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTextColor(String text) {
    return text.contains('https')
        ? Colors.blue
        : Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
  }

  TextDecoration _getTextDecoration(String text) {
    if (text.contains('https') && text.startsWith('http')) {
      return TextDecoration.underline;
    } else {
      return TextDecoration.none;
    }
  }

  Color _getTitleColor() {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  void findTextById(int id) {
    final webViewController = WebViewControllerManager().webViewController;
    if (webViewController != null) {
      webViewController.runJavascript('fLibrasClick($id);');
    }
  }
}
