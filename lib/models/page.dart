class Page{

  String name;
  String country;
  String bannerPicURL;
  String profilePicUrl;


  Page({
    required this.name,
    this.country = "",
    required this.bannerPicURL,
    required this.profilePicUrl,
  });

  get getName {
    return name;
  }

  get getCountry {
    return country;
  }

  String get getBannerPicURL {
    return bannerPicURL;
  }

  String get getProfilePicURL {
    return profilePicUrl;
  }

  void setName(String nName) {
    name = name;
  }

  void setCountry(String nUrl) {
    country = nUrl;
  }

  void setProfilePicture(String url) {
    profilePicUrl = url;
  }

  void setBannerPicture(String url) {
    bannerPicURL = url;
  }



  Map<String, dynamic> toJSON() => <String, dynamic>{
    'name': name,
    'country': country,
    'bannerPicUrl': '',
    'profilePicUrl': '',
  };

}