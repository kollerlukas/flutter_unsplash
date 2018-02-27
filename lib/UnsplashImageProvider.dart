import 'dart:convert';
import 'dart:io';

import 'package:unsplash_client/Keys.dart';
import 'package:unsplash_client/Models.dart';
import 'package:path_provider/path_provider.dart';

class UnsplashImageProvider {
  static requestImages() async {
    String url = 'https://api.unsplash.com/photos?page=1&per_page=100';
    var data = await getImages(url);
    List<UnsplashImage> images =
        new List<UnsplashImage>.generate(data.length, (index) {
      return new UnsplashImage(data[index]);
    });
    // return Images
    return images;
  }

  static requestImagesWithKeyword(String keyword) async {
    // Search for image associated with the keyword
    String url =
        'https://api.unsplash.com/search/photos?query=$keyword&page=1&per_page=100';
    var data = await getImages(url);
    List<UnsplashImage> images =
        new List<UnsplashImage>.generate(data['results'].length, (index) {
      return new UnsplashImage(data['results'][index]);
    });
    // return Images
    return images;
  }

  static getImages(String url) async {
    // setup Http Get
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    addClientIdToHeader(request);
    HttpClientResponse response = await request.close();
    // Process the response.
    if (response.statusCode == 200) {
      // response: OK
      // decode JSON
      String json = await response.transform(UTF8.decoder).join();
      var data = JSON.decode(json);
      return data;
    } else {
      // something went wrong :(
      print("Http error: ${response.statusCode}");
      return [];
    }
  }

  static downloadImage(UnsplashImage image) async {
    HttpClient httpClient = new HttpClient();
    String downloadUrl = image.getDownloadLink();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(downloadUrl));
    addClientIdToHeader(request);
    HttpClientResponse response = await request.close();
    // Process the response.
    if (response.statusCode == 200) {
      // response: OK
      String dir = (await getApplicationDocumentsDirectory()).path;
      // cant access public storage
      //response.pipe(new File('$dir/${image.getId()}.jpg').openWrite());
    } else {
      // something went wrong :(
      print("Http error: ${response.statusCode}");
    }
  }

  static addClientIdToHeader(HttpClientRequest request) {
    // pass the client_id in the header
    request.headers
        .add('Authorization', 'Client-ID ${Keys.UNSPLASH_API_CLIENT_ID}');
  }
}
