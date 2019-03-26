import 'dart:convert';
import 'dart:io';

import 'package:unsplash_client/Keys.dart';
import 'package:unsplash_client/Models.dart';

/// Helper class to interact with the Unsplash Api and provide images.
class UnsplashImageProvider {
  /// asynchronously request images from unsplash.
  /// @return received images
  static requestImages() async {
    String url = 'https://api.unsplash.com/photos?page=1&per_page=100';
    // receive image data from unsplash
    var data = await _getImageData(url);
    // generate UnsplashImage List from received data
    List<UnsplashImage> images =
        new List<UnsplashImage>.generate(data.length, (index) {
      return new UnsplashImage(data[index]);
    });
    // return images
    return images;
  }

  /// asynchronously request images from unsplash associated to a given keyword.
  /// @param keyword
  /// @return received images
  static requestImagesWithKeyword(String keyword) async {
    // Search for image associated with the keyword
    String url =
        'https://api.unsplash.com/search/photos?query=$keyword&page=1&per_page=100&order_by=popular';
    // receive image data from unsplash associated to the given keyword
    var data = await _getImageData(url);
    // generate UnsplashImage List from received data
    List<UnsplashImage> images =
        new List<UnsplashImage>.generate(data['results'].length, (index) {
      return new UnsplashImage(data['results'][index]);
    });
    // return Images
    return images;
  }

  /// receive image data from a given url and decode JSON
  /// @param url
  /// @return received data
  static _getImageData(String url) async {
    // setup http client
    HttpClient httpClient = new HttpClient();
    // setup http request
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    // pass the client_id in the header
    request.headers
        .add('Authorization', 'Client-ID ${Keys.UNSPLASH_API_CLIENT_ID}');

    // wait for response
    HttpClientResponse response = await request.close();
    // Process the response
    if (response.statusCode == 200) {
      // response: OK
      // decode JSON
      String json = await response.transform(utf8.decoder).join();
      // return decoded json
      return jsonDecode(json);
    } else {
      // something went wrong :(
      print("Http error: ${response.statusCode}");
      // return empty list
      return [];
    }
  }
}
