import 'dart:convert';
import 'dart:io';

import 'package:unsplash_client/keys.dart';
import 'package:unsplash_client/models.dart';

/// Helper class to interact with the Unsplash Api and provide [UnsplashImage].
class UnsplashImageProvider {
  /// Asynchronously loads a [UnsplashImage] for a given [id].
  static Future<UnsplashImage> loadImage(String id) async {
    String url = 'https://api.unsplash.com/photos/$id';
    // receive image data from unsplash
    var data = await _getImageData(url);
    // return image
    return UnsplashImage(data);
  }

  /// Asynchronously load a list of trending [UnsplashImage].
  /// Returns a list of [UnsplashImage].
  /// [page] is the page index for the api request.
  /// [perPage] sets the length of the returned list.
  static Future<List> loadImages({int page = 1, int perPage = 10}) async {
    String url = 'https://api.unsplash.com/photos?page=$page&per_page=$perPage';
    // receive image data from unsplash
    var data = await _getImageData(url);
    // generate UnsplashImage List from received data
    List<UnsplashImage> images =
        List<UnsplashImage>.generate(data.length, (index) {
      return UnsplashImage(data[index]);
    });
    // return images
    return images;
  }

  /// Asynchronously load a list of [UnsplashImage] associated to a given [keyword].
  /// Returns a list where the first element is the [totalPages] available and the second element is a list of [UnsplashImage].
  /// [page] is the page index for the api request.
  /// [perPage] sets the length of the returned list.
  static Future<List> loadImagesWithKeyword(String keyword,
      {int page = 1, int perPage = 10}) async {
    // Search for image associated with the keyword
    String url =
        'https://api.unsplash.com/search/photos?query=$keyword&page=$page&per_page=$perPage&order_by=popular';
    // receive image data from unsplash associated to the given keyword
    var data = await _getImageData(url);
    // generate UnsplashImage List from received data
    List<UnsplashImage> images =
        List<UnsplashImage>.generate(data['results'].length, (index) {
      return UnsplashImage(data['results'][index]);
    });
    int totalPages = data['total_pages'];
    // return Images
    return [totalPages, images];
  }

  /// Receive image data from a given [url] and return the JSON decoded the data.
  static dynamic _getImageData(String url) async {
    // setup http client
    HttpClient httpClient = HttpClient();
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
