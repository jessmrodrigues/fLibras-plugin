import 'package:flutter/material.dart';
import 'package:test_singleton/webview_controller_manager.dart';
import 'client/article.dart';
import 'flibras.dart';
import 'package:url_launcher/url_launcher.dart';


class FLibrasView extends StatefulWidget {
  final Article article;

  const FLibrasView({super.key, required this.article});

  @override
  // ignore: library_private_types_in_public_api
  _FLibrasViewState createState() => _FLibrasViewState();
}

class _FLibrasViewState extends State<FLibrasView> {
  late List<String> newsContentSentences;
  late String author;
  late String title;
  late String pubdate;
  bool isImageUrlValid = true;

  @override
  void initState() {
    super.initState();
    author = widget.article.author ?? "Autor Desconhecido";
    title = widget.article.title;
    pubdate = widget.article.pubdate ?? 'Data Desconhecida';
    newsContentSentences = _splitNewsContent(widget.article.description ?? '');
    _checkImageUrlValidity(widget.article.image_url);
  }

  List<String> _splitNewsContent(String text) {
    return text.split(RegExp(r'\. |\.')).map((sentence) => '$sentence.').toList();
  }

  void _checkImageUrlValidity(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      Image.network(imageUrl).image.resolve(const ImageConfiguration()).addListener(
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
            findTextById(1);
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
                if (isImageUrlValid && widget.article.image_url != null)
                  Image.network(
                    widget.article.image_url!,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          findTextById(0);
                        },
                        child: Text(
                          author + ' - ' + pubdate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: newsContentSentences
                            .map((sentence) => GestureDetector(
                                  onTap: () {
                                    findTextById(2);
                                  },
                                  child: Text(
                                    sentence,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Leia na Íntegra: ',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      GestureDetector(
                      onTap: () {
                        if (widget.article.link != null) {
                          launch(widget.article.link!);
                        }
                      },
                      child: Text(
                        "${widget.article.link}" ?? 'Fonte Desconhecida',
                        style: const TextStyle(
                          color: Colors.indigo,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ],
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
              child: fLibras(texts: [author, title, newsContentSentences.join(' ')]),
            ),
          )
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
