import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:unsplash_client/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unsplash_client/unsplash_image_provider.dart';

/// Screen for showing an individual [UnsplashImage].
class ImagePage extends StatefulWidget {
  final UnsplashImage image;

  ImagePage({Key key, this.image}) : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();
}

/// Provide a state for [ImagePage].
class _ImagePageState extends State<ImagePage> {
  /// create global key to show info bottom sheet
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// Bottomsheet controller
  PersistentBottomSheetController bottomSheetController;

  /// Displayed image.
  UnsplashImage image;

  @override
  void initState() {
    super.initState();
    // inital image
    image = widget.image;
    // load image
    _loadImage();
  }

  /// Reloads the image from unsplash to get extra data, like: exif, location, ...
  _loadImage() async {
    UnsplashImage image =
        await UnsplashImageProvider.loadImage(widget.image.getId());
    setState(() {
      this.image = image;
    });
  }

  /// Returns AppBar.
  Widget _buildAppBar() => AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading:
            // back button
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          // show image info
          IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              tooltip: 'Image Info',
              onPressed: () => _showInfoBottomSheet()),
          // open in browser icon button
          IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              tooltip: 'Open in Browser',
              onPressed: () => launch(image?.getHtmlLink())),
          // set as wallpaper
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Colors.white,
            ),
            tooltip: 'Download Image',
            onPressed: () => _downloadImage(),
          ),
        ],
      );

  /// Returns PhotoView around given [image].
  Widget _buildPhotoView(UnsplashImage image) => PhotoView(
        imageProvider: NetworkImage(image.getRegularUrl()),
        initialScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.covered,
        maxScale: PhotoViewComputedScale.covered,
        heroTag: '${widget.image.getId()}',
        loadingChild: const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        )),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // set the global key
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          /*image != null ?*/ _buildPhotoView(image) /*: null*/,
          // wrap in Positioned to not use entire screen
          Positioned(top: 0.0, left: 0.0, right: 0.0, child: _buildAppBar()),
        ].where((w) => w != null).toList(),
      ),
    );
  }

  /// Downloads the image and saves it to local storage.
  _downloadImage() async {
    // TODO
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('not implemented yet!')));
  }

  /// Shows a BottomSheet containing image info.
  PersistentBottomSheetController _showInfoBottomSheet() {
    return _scaffoldKey.currentState.showBottomSheet(
      (context) => Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () => launch(image?.getUser()?.getHtmlLink()),
                    child: Row(
                      children: <Widget>[
                        _buildUserProfileImage(
                            image?.getUser()?.getMediumProfileImage()),
                        Text(
                          '${image.getUser().getFirstName()} ${image?.getUser()?.getLastName()}',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            '${image.createdAtFormatted()}'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // don't show description if null
                  _buildDescriptionWidget(image.getDescription()),
                  // don't show location if null
                  _buildLocationWidget(image.getLocation()),
                  // show exif data
                  _buildExifWidget(image.getExif()),
                  // filter null views
                ].where((w) => w != null).toList()),
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
          ),
    );
  }

  /// Builds a round image widget displaying a profile image from a given [url].
  Widget _buildUserProfileImage(String url) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
      );

  Widget _buildDescriptionWidget(String description) => description != null
      ? Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          child: Text(
            '$description',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16.0,
              letterSpacing: 0.1,
            ),
          ),
        )
      : null;

  /// Builds a widget displaying location, where the image was captured.
  Widget _buildLocationWidget(Location location) => location != null
      ? Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black54,
                  )),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '${location.getCity()}, ${location.getCountry()}'
                        .toUpperCase(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        )
      : null;

  /// Builds a widget displaying all Exif data
  Widget _buildExifWidget(Exif exif) => exif != null
      ? Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.black54,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                      child: Text(
                        '${exif.getModel()}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      )),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                        child: Text(
                          'ƒ${exif.getAperture()}',
                          style: TextStyle(
                              color: Colors.black26,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                          child: Text(
                            '${exif.getExposureTime()}',
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                          child: Text(
                            '${exif.getFocalLength()} mm',
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                          child: Text(
                            'ISO${exif.getIso()}',
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              )
            ],
          ))
      : null;
}
