import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_client/image_page.dart';
import 'package:unsplash_client/models.dart';
import 'package:unsplash_client/unsplash_image_provider.dart';

/// MainPage
/// Showing a collection of trending unsplash images.
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

/// State for MainPage
class _MainPageState extends State<MainPage> {
  /// images fetched from unsplash
  List<UnsplashImage> images = [];

  /// searched keyword
  String keyword;

  @override
  initState() {
    super.initState();
    // initial image Request
    _requestImages();
  }

  /// request images from unsplash and update the UI
  _requestImages() async {
    // display loading indicator
    setState(() {
      // set new fetched images
      this.images = [];
      // keyword null
      this.keyword = null;
    });
    // request images from unplash
    List<UnsplashImage> images = await UnsplashImageProvider.requestImages();
    // update UI => set state
    setState(() {
      // set new fetched images
      this.images = images;
    });
  }

  /// request images from unsplash and update the UI
  _requestImagesWithKeyword(String keyword) async {
    // display loading indicator
    setState(() {
      // set new fetched images
      this.images = [];
      // set searched keyword
      this.keyword = keyword;
    });
    // request images with a keyword
    List<UnsplashImage> images =
        await UnsplashImageProvider.requestImagesWithKeyword(keyword);
    // update UI => set state
    setState(() {
      // set new fetched images
      this.images = images;
    });
  }

  /// reset from the searched state
  _resetSearchedState() {
    // show regular images
    _requestImages();
  }

  /// return the SearchAppBar
  _getSearchAppBar() {
    if (keyword != null) {
      return SliverAppBar(
        title: TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.black54, fontSize: 17.0),
              border: InputBorder.none),
          onSubmitted: (String keyword) {
            // search and display images associated to the keyword
            _requestImagesWithKeyword(keyword);
          },
          autofocus: true,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            color: Colors.black87,
            onPressed: () {
              /* reset the state */
              _resetSearchedState();
            },
          )
        ],
        backgroundColor: Colors.grey[50],
      );
    } else {
      return SliverAppBar(
        title:
            Text('Flutter Unsplash', style: TextStyle(color: Colors.black87)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black87,
            onPressed: () {
              /* go into searching state */
              setState(() {
                keyword = "";
              });
            },
          )
        ],
        backgroundColor: Colors.grey[50],
      );
    }
  }

  /// return the loading indicator widget that is displayed during loading
  _getLoadingIndicatorWidget() => Center(
        child: CircularProgressIndicator(),
      );

  /// return the grid with the loaded images
  _getImageGridWidget() => OrientationBuilder(
        builder: (context, orientation) {
          return StaggeredGridView.countBuilder(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () {
                    /* item onclick */
                    Navigator.of(context).push(
                      MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          /* open image Page */
                          return ImagePage(image: images[index]);
                        },
                      ),
                    );
                  },
                  // Main route
                  child: Hero(
                    tag: '${images[index].getId()}',
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image.network(images[index].getSmallUrl(),
                            fit: BoxFit.cover)),
                  ),
                ),
            staggeredTileBuilder: (int index) {
              return StaggeredTile.fit(1);
            },
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 15.0,
            padding: const EdgeInsets.all(15.0),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[_getSearchAppBar()];
            },
            // GridView
            /* either display loading indicator or Image grid */
            body: images.isEmpty
                ? _getLoadingIndicatorWidget()
                : _getImageGridWidget()));
  }
}
