import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:udhyogulu/apis.dart';
import 'package:udhyogulu/article_web_view.dart';
import 'package:udhyogulu/articles_list.dart';
import 'package:udhyogulu/storage.dart';

class NewsDrawer extends StatefulWidget {
  @override
  _NewsDrawerState createState() => _NewsDrawerState();
}

class _NewsDrawerState extends State<NewsDrawer>
    with AutomaticKeepAliveClientMixin {
  final String url =
      'http://ec2-35-154-205-9.ap-south-1.compute.amazonaws.com/udhyoguluapi/';
  List<dynamic> notes = [];

  initState() {
    super.initState();
    fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    var result = await http.get(url + APIS.NOTES);
    var r = utf8.decode(result.bodyBytes);
    notes = json.decode(r)['notes'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Colors.red,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'ఉద్యోగులు',
                    style: TextStyle(
                        fontFamily: 'Header',
                        fontSize: 48,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: Storage.states.length != 0
                      ? List<Widget>.generate(Storage.states.length, (index) {
                            return ExpansionTile(
                              title: Text(
                                Storage.states[index]['state_name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                              children: List.generate(
                                  Storage.states[index]['districts'].length, (i) {
                                return ListTile(
                                  title: Text(Storage.states[index]['districts'][i]
                                      ['district_name']),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ArticlesList(
                                              Storage.states[index]['state_name']
                                            ,  Storage.states[index]['districts'][i]
                                                  ['district_name'],
                                              Storage.states[index]['districts'][i]
                                                  ['district_url']),
                                        ));
                                  },
                                );
                              }),
                            );
                          }) +
                          List<Widget>.generate(notes.length, (index) {
                            return ListTile(
                              title: Text(notes[index]['note_name']),
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArticleWeb(url:notes[index]['note_weburl']),
                                    ));
                              },
                            );
                          })
                      : [
                          LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.red),
                            backgroundColor: Colors.white,
                          )
                        ],
                ),
              ),
            )
          ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
