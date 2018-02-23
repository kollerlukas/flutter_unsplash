import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:unsplash_client/Keys.dart';

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
  List<String> urls = [];

  SearchBar searchBar;

  @override
  void initState() {
    super.initState();
    // init SearchBar
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        buildDefaultAppBar: buildAppBar
    );
  }

  // get Image urls
  void requestImages(String keyword) {
    // Search for image associated with the keyword
    String url =
        'https://api.unsplash.com/search/photos?query=$keyword&per_page=100';

    HttpClient httpClient = new HttpClient();
    httpClient.getUrl(Uri.parse(url)).then((request) {
      // pass the client_id in the header
      request.headers.add('Authorization', 'Client-ID ${Keys.UNSPLASH_API_CLIENT_ID}');
      // Then call close.
      return request.close();
    }).then((response) {
      // Process the response.
      if (response.statusCode == 200) {
        // response: OK
        // decode JSON
        response.transform(UTF8.decoder).join().then((String json) {
          var data = JSON.decode(json);
          // extract urls from the JSON
          List<String> urls =
              new List<String>.generate(data['results'].length, (index) {
            return data['results'][index]['urls']['small'];
          });
          // set the State
          setState(() {
            this.urls = urls;
          });
        });
      } else {
        // something went wrong :(
        print("Http error: ${response.statusCode}");
      }
    });
  }

  // For the SearchBar
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Unsplash Wallpapers'),
        actions: [searchBar.getSearchAction(context)]);
  }

  // callback for the SearchBar
  void onSubmitted(String keyword) {
    // search for images associated to the keyword
    requestImages(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // set SearchBar as AppBar
      appBar: searchBar.build(context),
      // GridView
      body: new GridView.count(
        // 2 column
        crossAxisCount: 2,
        // some padding
        padding: const EdgeInsets.all(10.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        // init the individual ImageViews
        children: new List<Widget>.generate(urls.length, (index) {
          return new GridTile(
              child: new Card(
                  child: new Image.network(urls[index], fit: BoxFit.cover)));
        }),
      ),
    );
  }
}
