import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:udhyogulu/article.dart';

class Category extends StatefulWidget {
  final category;

  const Category({Key key, this.category}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<dynamic> subcategories, subcatarticles = [];

  BoxDecoration selected_cont, unselected_cont;
  int selected_sub_cat = 0;

  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    subcategories = widget.category['sub_category'];
    selected_cont = BoxDecoration(
      color: Colors.blue,
    );
    unselected_cont = BoxDecoration(
        color: Colors.white, border: Border.all(color: Colors.blue, width: 0.5));
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (10 + subcatarticles[selected_sub_cat]['viewlength'] < subcatarticles[selected_sub_cat]['length'])
          subcatarticles[selected_sub_cat]['viewlength'] += 10;
        else {
          subcatarticles[selected_sub_cat]['viewlength'] = subcatarticles[selected_sub_cat]['length'];
        }
        setState(() {});
      }
    });
    super.initState();
    fetchArticles();
  }

  fetchArticles() async {
    for (int i = 0; i < widget.category['sub_category'].length; i++) {
      var result = await http
          .get(widget.category['sub_category'][i]['subcategory_url']);
      var r = utf8.decode(result.bodyBytes);
      subcatarticles.add({
        'articles': json.decode(r)['articles'],
        'length': json.decode(r)['totalResults'],
        'viewlength':0
      });
      if (subcatarticles[i]['length'] > 10)
        subcatarticles[i]['viewlength'] = 10;
      else
        subcatarticles[i]['viewlength'] = subcatarticles[i]['length'];

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'ఉద్యోగులు',
            style: TextStyle(fontFamily: 'Header', fontSize: 24),
          ),
        ),
        bottom: PreferredSize(
            child: Container(
              height: 56,
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                      widget.category['sub_category'].length,
                      (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          scrollController.jumpTo(0);
                          selected_sub_cat = index;
                        });
                      },
                      child: Container(
                        height: 38,
                        decoration: selected_sub_cat == index
                            ? selected_cont
                            : unselected_cont,
                        padding: const EdgeInsets.fromLTRB(8,4,10,0),
                        margin: const EdgeInsets.all(6),
                        child: Center(
                          child: Text(
                            widget.category['sub_category'][index]
                                ['subcategory_name'],
                            style: TextStyle(
                                color: selected_sub_cat == index
                                    ? Colors.white
                                    : Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(56)),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: <Widget>[
            //Articles
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List<Widget>.generate(subcatarticles.length!=0?subcatarticles[selected_sub_cat]['viewlength']:0, (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Article(subcatarticles[selected_sub_cat]['articles'][index]),
                            ));
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
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
                                    subcatarticles[selected_sub_cat]['articles'][index]['urlToImage'],
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
                                          subcatarticles[selected_sub_cat]['articles'][index]['title'],
                                      style: TextStyle(
                                          fontFamily: 'Header', fontSize: 18),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Flexible(
                                        child: Text(
                                          subcatarticles[selected_sub_cat]['articles'][index]['description'],
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
                  }) +
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(subcatarticles.length!=0?subcatarticles[selected_sub_cat]['viewlength'] == subcatarticles[selected_sub_cat]['length']
                                ? '____'
                                : 'Loading....':'____'),
                      ),
                    )
                  ],
            )
          ],
        ),
      ),
    );
  }
}
