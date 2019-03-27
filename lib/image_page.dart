import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:unsplash_client/models.dart';
import 'package:url_launcher/url_launcher.dart';

/// ImagePage
/// Showing an individual image.
class ImagePage extends StatefulWidget {
  final UnsplashImage image;

  ImagePage({Key key, this.image}) : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();
}

/// State for ImagePage
class _ImagePageState extends State<ImagePage> {
  _downloadImage() async {
    // TODO
  }

  /// return app bar
  _getAppBar() =>
      // wrap in Positioned to not use entire screen
      Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading:
                /* back button */
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white70,
                    ),
                    onPressed: (() {
                      Navigator.pop(context);
                    })),
            actions: <Widget>[
              /* open in browser icon button */
              IconButton(
                  icon: Icon(
                    Icons.open_in_browser,
                    color: Colors.white70,
                  ),
                  tooltip: 'Open in Browser',
                  onPressed: () {
                    /* open url in browser */
                    launch(widget.image.getDownloadLink());
                  }),
              /* set as wallpaper */
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Colors.white70,
                ),
                onPressed: () {
                  /* download image */
                  _downloadImage();
                },
              ),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: _getAppBar(),*/
      body: Stack(
        children: <Widget>[
          PhotoView(
              imageProvider: NetworkImage(widget.image.getRegularUrl()),
              initialScale: PhotoViewComputedScale.covered,
              minScale: PhotoViewComputedScale.covered,
              maxScale: PhotoViewComputedScale.covered,
              heroTag: '${widget.image.getId()}'),
          _getAppBar(),
        ],
      ),
    );
  }
}
