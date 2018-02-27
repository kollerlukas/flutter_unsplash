// Model for Unsplash Image
class UnsplashImage {
  var data;

  UnsplashImage(var data) {
    this.data = data;
  }

  // Getter

  getId() {
    return data['id'];
  }

  createdAt() {
    return data['created_at'];
  }

  getWidth() {
    return data['width'];
  }

  getHeight() {
    return data['height'];
  }

  getColor() {
    return data['color'];
  }

  getLikes() {
    return data['likes'];
  }

  isLikedByUser() {
    return data['liked_by_user'];
  }

  getDescription() {
    return data['description'];
  }

  UnsplashUser getUser() {
    return new UnsplashUser(data['user']);
  }

  getUrls() {
    return data['urls'];
  }

  getRawUrl() {
    return getUrls()['raw'];
  }

  getFullUrl() {
    return getUrls()['full'];
  }

  getRegularUrl() {
    return getUrls()['regular'];
  }

  getSmallUrl() {
    return getUrls()['small'];
  }

  getThumbUrl() {
    return getUrls()['thumb'];
  }

  getLinks() {
    return data['links'];
  }

  getSelfLink() {
    return getLinks()['self'];
  }

  getHtmlLink() {
    return getLinks()['html'];
  }

  getDownloadLink() {
    return getLinks()['download'];
  }
}

// Model for Unsplash User
class UnsplashUser {
  var data;

  UnsplashUser(var data) {
    this.data = data;
  }

  // Getter

  getId() {
    return data['id'];
  }

  getUsername() {
    return data['username'];
  }

  getFirstName() {
    return data['first_name'];
  }

  getLastName() {
    return data['last_name'];
  }

  getInstagramUsername() {
    return data['instagram_username'];
  }

  getTwitterUsername() {
    return data['twitter_username'];
  }

  getPortfolioUrl() {
    return data['portfolio_url'];
  }

  getProfileImages() {
    return data['profile_image'];
  }

  getSmallProfileImage() {
    return getProfileImages()['small'];
  }

  getMediumProfileImage() {
    return getProfileImages()['medium'];
  }

  getLargeProfileImage() {
    return getProfileImages()['large'];
  }

  getLinks() {
    return data['links'];
  }

  getSelfLink() {
    return getLinks()['self'];
  }

  getHtmlLink() {
    return getLinks()['html'];
  }

  getPhotosLink() {
    return getLinks()['photos'];
  }

  getLikesLink() {
    return getLinks()['likes'];
  }

  getCurrentUserCollections() {
    return data['current_user_collections'];
  }
}
