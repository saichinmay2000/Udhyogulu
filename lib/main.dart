import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:udhyogulu/apis.dart';
import 'package:udhyogulu/drawer.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.red),
    home: MyHomePage(
    ),
  ));
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url =
      'http://ec2-35-154-205-9.ap-south-1.compute.amazonaws.com/udhyoguluapi/';
  List<dynamic> categories = [], slider = [], top_stories = [];
  ScrollController top_stories_scrollController = new ScrollController();

  int top_stories_viewlength = 0;

  initState() {
    top_stories_scrollController.addListener(() {
      if (top_stories_scrollController.offset >=
          top_stories_scrollController.position.maxScrollExtent &&
          !top_stories_scrollController.position.outOfRange) {
        if (10 + top_stories_viewlength < top_stories.length)
          top_stories_viewlength += 10;
        else{
          top_stories_viewlength = top_stories.length;
        }
        setState(() {});
      }});
    super.initState();
    fetchData();
  }


  @override
  void dispose() {
    top_stories_scrollController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchData() async {
    var result = await http.get(url + APIS.CATEGORIES);
    var r = utf8.decode(result.bodyBytes);
    categories = json.decode(r)['categories'];
    setState(() {});
    result = await http.get(url + APIS.SLIDER_IMAGES);
    r = utf8.decode(result.bodyBytes);
    slider = json.decode(r)['sliders'];
    setState(() {});
    result = await http.get(url + APIS.TOP_STORIES);
    r = utf8.decode(result.bodyBytes);
    top_stories = json.decode(r)['articles'];
    if (top_stories.length > 10)
      top_stories_viewlength = 10;
    else
      top_stories_viewlength = top_stories.length;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        bottom: PreferredSize(
            child: Container(
              height: 56,
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(categories.length, (index) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        margin: const EdgeInsets.all(6),
                        child: Center(
                          child: Text(
                            categories[index]['category_name'],
                            style: TextStyle(
                                color: Colors.white,
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
        controller: top_stories_scrollController,
        child: Column(
          children: <Widget>[
            //Slider
            Container(
                height: 232,
                padding: const EdgeInsets.all(9),
                color: Colors.white,
                child: slider.length != 0
                    ? Carousel(
                        autoplay: true,
                        dotBgColor: Colors.transparent,
                        dotColor: Colors.black54,
                        autoplayDuration: Duration(seconds: 8),
                        images: List.generate(
                            slider.length,
                            (index) => Container(
                                height: 200,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    slider[index]['slider_image'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ))),
                      )
                    : Container()),
            //Top Stories
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(top_stories_viewlength, (index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                              top_stories[index]['urlToImage'],
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
                                top_stories[index]['title'],
                                style: TextStyle(
                                    fontFamily: 'Header', fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              Flexible(
                                  child: Text(
                                top_stories[index]['description'],
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
                );
              }),
            )
          ],
        ),
      ),
      drawer: NewsDrawer(),
    );
  }
}
