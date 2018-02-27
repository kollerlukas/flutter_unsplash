import 'package:flutter/material.dart';
import 'package:unsplash_client/Models.dart';
import 'package:unsplash_client/UnsplashImageProvider.dart';
import 'package:share/share.dart';

void main() => runApp(new UnsplashClient());

class UnsplashClient extends StatelessWidget {
  final String title = 'Unsplash Client';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        accentIconTheme: new IconThemeData(color: Colors.black87),
        fontFamily: 'Roboto Mono',
        textSelectionHandleColor: Colors.black87,
      ),
      home: new MyHomePage(title: title),
    );
  }
}

// HomePage
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UnsplashImage> images = [];

  @override
  initState() {
    super.initState();
    // initial Request
    initialRequest();
  }

  initialRequest() async {
    List<UnsplashImage> images = await UnsplashImageProvider.requestImages();
    setState(() {
      this.images = images;
    });
  }

  requestByKeyWord(String keyword) async {
    List<UnsplashImage> images =
        await UnsplashImageProvider.requestImagesWithKeyword(keyword);
    setState(() {
      this.images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // set SearchBar as AppBar
      appBar: new AppBar(
        leading: new Icon(
          Icons.search,
          color: Colors.black87,
        ),
        title: new TextField(
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
              hintText: 'Search',
              hintStyle: new TextStyle(color: Colors.black54, fontSize: 17.0),
              border: null),
          onSubmitted: (String keyword) {
            // search for images associated to the keyword
            requestByKeyWord(keyword);
          },
        ),
      ),
      // GridView
      body: new GridView.count(
        // 2 column
        crossAxisCount: 2,
        // some padding
        padding: const EdgeInsets.all(10.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        // init the individual ImageViews
        children: new List<Widget>.generate(images.length, (index) {
          return new GridTile(
              child: new InkWell(
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new ImagePage(image: images[index]);
                  },
                ),
              );
            },
            // Main route
            child: new Hero(
                tag: '${images[index].getId()}',
                child: new Image.network(images[index].getRegularUrl(),
                    fit: BoxFit.cover)),
          ));
        }),
      ),
    );
  }
}

// ImagePage
class ImagePage extends StatefulWidget {
  final UnsplashImage image;

  ImagePage({Key key, this.image}) : super(key: key);

  @override
  _ImagePageState createState() => new _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(children: <Widget>[
        new Stack(
          children: <Widget>[
            new Hero(
              tag: '${widget.image.getId()}',
              child: new Image.network(widget.image.getRegularUrl(),
                  fit: BoxFit.cover),
            ),
            new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.white70,
                ),
                onPressed: (() {
                  Navigator.pop(context);
                }))
          ],
        ),
        new Row(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.all(8.0),
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new NetworkImage(
                          widget.image.getUser().getLargeProfileImage()),
                      fit: BoxFit.cover),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(25.0))),
            ),
            new Text(
              '${widget.image.getUser().getFirstName()} ${widget.image
                  .getUser()
                  .getLastName()}',
              style: new TextStyle(
                fontSize: 17.0,
              ),
            )
          ],
        )
      ]),
      floatingActionButton: new FloatingActionButton(
        onPressed: (() {
          print('downloadImage()');
          //UnsplashImageProvider.downloadImage(widget.image);
        }),
        tooltip: 'Download Image',
        child: new Icon(
          Icons.file_download,
        ),
      ),
    );
  }
}
