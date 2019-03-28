import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_client/image_page.dart';
import 'package:unsplash_client/models.dart';
import 'package:unsplash_client/unsplash_image_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Screen for showing a collection of trending [UnsplashImage].
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

/// Provide a state for [MainPage].
class _MainPageState extends State<MainPage> {
  /// Stores the current page index for the api requests.
  int page = 0;

  /// Stores the currently loaded loaded images.
  List<UnsplashImage> images = [];

  /// States whether there is currently a task running loading images.
  bool loadingImages = false;

  /// Stored the currently searched keyword.
  String keyword;

  @override
  initState() {
    super.initState();
    // initial image Request
    _loadImages();
  }

  /// Resets the state to the inital state.
  _resetImages() {
    // clear image list
    images = [];
    // reset page counter
    page = 0;
    // reset keyword
    keyword = null;
    // show regular images
    _loadImages();
  }

  /// Requests a list of [UnsplashImage] for a given [keyword].
  /// If the given [keyword] is null, trending images are loaded.
  _loadImages({String keyword}) async {
    // check if there is currently a loading task running
    if (loadingImages) {
      // there is currently a task running
      return;
    }
    debugPrint("_loadImages() called, page=$page");
    // set loading state
    setState(() {
      // set loading
      loadingImages = true;
      // keyword null
      this.keyword = keyword;
    });

    // load images
    List<UnsplashImage> images;
    if (keyword == null) {
      // load images from the next page of trending images
      images = await UnsplashImageProvider.loadImages(page: ++page);
    } else {
      // load images from the next page with a keyword
      images = await UnsplashImageProvider.loadImagesWithKeyword(keyword,
          page: ++page);
    }

    if (images == []) {
      // error
      // TODO: handle errors
    }

    // update the state
    setState(() {
      // done loading
      loadingImages = false;
      // set new loaded images
      this.images.addAll(images);
    });
  }

  /// Asynchronously loads a [UnsplashImage] for a given [index].
  Future<UnsplashImage> _loadImage(int index) async {
    if (index < images.length) {
      return images[index];
    } else {
      // TODO: load more images
      //return images[index % images.length];
      // load more images
      _loadImages(keyword: keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OrientationBuilder(
            builder: (context, orientation) => CustomScrollView(
                    // put AppBar in NestedScrollView to have it sliver off on scrolling
                    slivers: <Widget>[
                  _buildSearchAppBar(),
                  _buildImageGrid(orientation: orientation),
                  // loading indicator at the bottom of the list
                  loadingImages
                      ? SliverToBoxAdapter(
                          child: _buildLoadingIndicator(),
                        )
                      : null,
                  // filter null views
                ].where((w) => w != null).toList())));
  }

  /// Returns the SearchAppBar.
  Widget _buildSearchAppBar() => SliverAppBar(
        title: keyword != null
            ?
            // either search-field or just the title
            TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 17.0),
                    border: InputBorder.none),
                onSubmitted: (String keyword) =>
                    // search and display images associated to the keyword
                    _loadImages(keyword: keyword),
                autofocus: true,
              )
            : const Text('Flutter Unsplash',
                style: TextStyle(color: Colors.black87)),
        actions: <Widget>[
          // either search oder clear button
          keyword != null
              ? IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.black87,
                  onPressed: () {
                    // reset the state
                    _resetImages();
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.black87,
                  onPressed: () =>
                      // go into searching state
                      setState(() => keyword = ""),
                )
        ],
        backgroundColor: Colors.grey[50],
      );

  /// Returns the loading indicator widget that is displayed during loading.
  Widget _buildLoadingIndicator() => const Center(
          child: Padding(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
        ),
        padding: const EdgeInsets.all(16.0),
      ));

  /// Returns the grid that displays images.
  /// [orientation] can be used to adjust the grid column count.
  Widget _buildImageGrid({orientation = Orientation.portrait}) => SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverStaggeredGrid.countBuilder(
          // set column count
          crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
          itemCount: images.length,
          // set itemBuilder
          itemBuilder: (BuildContext context, int index) =>
              _buildImageItemBuilder(index),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1)
              /*StaggeredTile.count(1, 1)*/,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
      );

  /// Returns a FutureBuilder to load a [UnsplashImage] for a given [index].
  Widget _buildImageItemBuilder(int index) => FutureBuilder(
        // pass image loader
        future: _loadImage(index),
        builder: (context, snapshot) =>
            // image loaded return InkWell
            _buildImageCard(snapshot.data),
      );

  /// Adds rounded corners to a given [widget].
  Widget _addRoundedCorners(Widget widget) =>
      // wrap in ClipRRect to achieve rounded corners
      ClipRRect(borderRadius: BorderRadius.circular(4.0), child: widget);

  /// Returns a placeholder to show until an image is loaded.
  Widget _buildImagePlaceholder() => _addRoundedCorners(
        Container(
          color: Colors.grey[200],
          child: _buildLoadingIndicator(),
        ),
      );

  /// Build a card for displaying a given [image].
  /// If given [image] is null then a grey placeholder is displayed.
  Widget _buildImageCard(UnsplashImage image) => InkWell(
        onTap: () {
          // item onclick
          Navigator.of(context).push(
            MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  // open [ImagePage] with the given image
                  ImagePage(image: image),
            ),
          );
        },
        // Hero Widget for Hero animation with [ImagePage]
        child: image != null
            ? Hero(
                tag: '${image?.getId()}',
                child: _addRoundedCorners(CachedNetworkImage(
                  imageUrl: image?.getSmallUrl(),
                  placeholder: (context, url) => _buildImagePlaceholder(),
                  fit: BoxFit.cover,
                )),
              )
            : _buildImagePlaceholder(),
      );
}
