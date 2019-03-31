import 'package:date_format/date_format.dart';

/// Model for Unsplash Image
class UnsplashImage {
  var data;

  UnsplashImage(this.data);

  // Getter

  String getId() {
    return data['id'];
  }

  String createdAt() {
    return data['created_at'];
  }

  String createdAtFormatted() {
    return formatDate(DateTime.parse(createdAt()), [dd, '. ', M, ' ', yyyy]);
  }

  String updatedAt() {
    return data['updated_at'];
  }

  Location getLocation() {
    return data['location'] != null ? Location(data['location']) : null;
  }

  Exif getExif() {
    return data['exif'] != null ? Exif(data['exif']) : null;
  }

  int getWidth() {
    return data['width'];
  }

  int getHeight() {
    return data['height'];
  }

  String getColor() {
    return data['color'];
  }

  int getLikes() {
    return data['likes'];
  }

  bool isLikedByUser() {
    return data['liked_by_user'];
  }

  String getDescription() {
    return data['description'];
  }

  String getAltDescription() {
    return data['alt_description'];
  }

  UnsplashUser getUser() {
    return UnsplashUser(data['user']);
  }

  getUrls() {
    return data['urls'];
  }

  String getRawUrl() {
    return getUrls()['raw'];
  }

  String getFullUrl() {
    return getUrls()['full'];
  }

  String getRegularUrl() {
    return getUrls()['regular'];
  }

  String getSmallUrl() {
    return getUrls()['small'];
  }

  String getThumbUrl() {
    return getUrls()['thumb'];
  }

  getLinks() {
    return data['links'];
  }

  String getSelfLink() {
    return getLinks()['self'];
  }

  String getHtmlLink() {
    return getLinks()['html'];
  }

  String getDownloadLink() {
    return getLinks()['download'];
  }
}

/// Model for Unsplash User
class UnsplashUser {
  var data;

  UnsplashUser(this.data);

  // Getter

  String getId() {
    return data['id'];
  }

  String getUsername() {
    return data['username'];
  }

  String getFirstName() {
    return data['first_name'];
  }

  String getLastName() {
    return data['last_name'];
  }

  String getInstagramUsername() {
    return data['instagram_username'];
  }

  String getTwitterUsername() {
    return data['twitter_username'];
  }

  String getPortfolioUrl() {
    return data['portfolio_url'];
  }

  getProfileImages() {
    return data['profile_image'];
  }

  String getSmallProfileImage() {
    return getProfileImages()['small'];
  }

  String getMediumProfileImage() {
    return getProfileImages()['medium'];
  }

  String getLargeProfileImage() {
    return getProfileImages()['large'];
  }

  getLinks() {
    return data['links'];
  }

  String getSelfLink() {
    return getLinks()['self'];
  }

  String getHtmlLink() {
    return getLinks()['html'];
  }

  String getPhotosLink() {
    return getLinks()['photos'];
  }

  String getLikesLink() {
    return getLinks()['likes'];
  }

  getCurrentUserCollections() {
    return data['current_user_collections'];
  }
}

/// Model for image location.
class Location {
  var data;

  Location(this.data);

  String getCity() {
    return data['city'];
  }

  String getCountry() {
    return data['country'];
  }
}

/// Model for the exif data of an image.
class Exif {
  var data;

  Exif(this.data);

  // Getter

  String getMake() {
    return data['make'];
  }

  String getModel() {
    return data['model'];
  }

  String getExposureTime() {
    return data['exposure_time'];
  }

  String getAperture() {
    return data['aperture'];
  }

  String getFocalLength() {
    return data['focal_length'];
  }

  int getIso() {
    return data['iso'];
  }
}
