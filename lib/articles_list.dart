import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:udhyogulu/apis.dart';
import 'package:http/http.dart' as http;
import 'package:udhyogulu/article.dart';

class ArticlesList extends StatefulWidget {
  String title, link,state;

  ArticlesList(this.state,this.title, this.link);

  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  List<dynamic> articles = [];
  ScrollController scrollController = new ScrollController();

  int viewlength = 0;

  initState() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (10 + viewlength < articles.length)
          viewlength += 10;
        else{
          viewlength = articles.length;
        }

        setState(() {});
      }
    });
    super.initState();
    fetchData();
  }


  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchData() async {
    var result = await http.get(widget.link);
    var r = utf8.decode(result.bodyBytes);
    articles = json.decode(r)['articles'];
    if (articles.length > 10)
      viewlength = 10;
    else
      viewlength = articles.length;

    setState(() {});
  }

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
            widget.state,
            style: TextStyle(fontFamily: 'Header', fontSize: 24),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8),
                  child: Center(
                    child: Text(
                      '${widget.title} ',
                      style: TextStyle(fontFamily: 'Header', fontSize: 48),
                    ),
                  ),
                )
              ] +
              List<Widget>.generate(viewlength, (index) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Article(articles[index]),));
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      height: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                articles[index]['urlToImage'],
                                width: 100,
                                height: 100,
                              )),
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 124,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 4,
                                ),
                                Flexible(
                                    child: Text(
                                  articles[index]['title'],
                                  style: TextStyle(
                                      fontFamily: 'Header', fontSize: 18),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                Flexible(
                                    child: Text(
                                  articles[index]['description'],
                                  style: TextStyle(fontFamily: 'Desc'),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })+[Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text(viewlength==articles.length?'____':'Loading....')),
              )],
        ),
      ),
    );
  }
}
