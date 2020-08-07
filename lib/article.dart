import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Article extends StatefulWidget {
  final article;

  Article(this.article);

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Text(
            'ఉద్యోగులు',
            style: TextStyle(fontFamily: 'Header', fontSize: 24),
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 220,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: PreferredSize(
                  child: Container(
                    height: 220,
                    child: Image.network(
                      '${widget.article['urlToImage']}',
                      height: 220,
                      fit: BoxFit.fill,
                    ),
                  ),
                  preferredSize: Size.fromHeight(220)),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.article['title']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Header',
                          fontSize: 28),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${widget.article['description']}',
                      style: TextStyle(
                          color: Colors.black,fontFamily: 'Desc',
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
