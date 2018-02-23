import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Unsplash Client',
      theme: new ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String client_id =
      'ab7804f9f2d18cddb6cdace2ae5e957bdd9deec3dd16ce1280e7069be81f6d33';
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    String keyword = 'car';
    requestImages(keyword);
  }

  void requestImages(String keyword) {
    String url =
        'https://api.unsplash.com/search/photos?query=$keyword&per_page=100';

    HttpClient httpClient = new HttpClient();
    httpClient.getUrl(Uri.parse(url)).then((request) {
      // Optionally set up headers...
      // Optionally write to the request object...
      request.headers.add('Authorization', 'Client-ID $client_id');
      // Then call close.
      return request.close();
    }).then((response) {
      // Process the response.
      if (response.statusCode == 200) {
        response.transform(UTF8.decoder).join().then((String json) {
          var data = JSON.decode(json);
          List<String> urls =
              new List<String>.generate(data['results'].length, (index) {
            return data['results'][index]['urls']['small'];
          });
          setState(() {
            this.urls = urls;
          });
        });
      } else {
        print("Http error: ${response.statusCode}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: new List<Widget>.generate(urls.length, (index) {
          return new GridTile(
              child: new Card(
                  child: new Image.network(urls[index], fit: BoxFit.cover)));
        }),
      ),
    );
  }
}
