import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            findTextById(contentList.indexOf(title));
          },
          child: Text(
            title,
          ),
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
                        .map((entry) => GestureDetector(
                              onTap: () {
                                if (entry.value.contains('https')) {
                                  launchUrl(Uri.parse(widget.article.link!));
                                } else {
                                  findTextById(entry.key);
                                }
                              },
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: entry.value.contains('https')
                                      ? Colors.indigo
                                      : Colors.black,
                                  decoration: entry.value.contains('https')
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
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
    );
  }

  void findTextById(int id) {
    final webViewController = WebViewControllerManager().webViewController;
    if (webViewController != null) {
      webViewController.runJavascript('fLibrasClick($id);');
    }
  }
}
