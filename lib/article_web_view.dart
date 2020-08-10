import 'package:flutter/material.dart';
import 'package:udhyogulu/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWeb extends StatefulWidget {

  final url;

  const ArticleWeb({Key key, this.url}) : super(key: key);

  @override
  _ArticleWebState createState() => _ArticleWebState();
}

class _ArticleWebState extends State<ArticleWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              })
        ],
        backgroundColor: Colors.red,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'ఉద్యోగులు',
            style: TextStyle(fontFamily: 'Header', fontSize: 24),
          ),
        ),
      ),
      body: Builder(
        builder: (context) => WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,

        ),
      ),
    );
  }
}
