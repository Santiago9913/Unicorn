class UserPage {
  String name;
  String country;
  String? bannerPicURL;
  String? profilePicUrl;
  bool useICO;
  String preferredFinancial;
  String preferredFramewok;
  String ownerUID;
  Map<String, int> preferences;
  String type;

  UserPage({
    required this.name,
    required this.country,
    this.bannerPicURL = "",
    this.profilePicUrl = "",
    required this.useICO,
    required this.preferredFinancial,
    required this.preferredFramewok,
    required this.ownerUID,
    required this.preferences,
    required this.type,
  });

  String get getName {
    return name;
  }

  String get getCountry {
    return country;
  }

  String? get getBannerPicURL {
    return bannerPicURL;
  }

  String? get getProfilePicURL {
    return profilePicUrl;
  }

  bool get getUseICO {
    return useICO;
  }

  String get getPreferredFinancial {
    return preferredFinancial;
  }

  String get getpreferredFramewok {
    return preferredFramewok;
  }

  String get getPageOwnerUID {
    return ownerUID;
  }

  Map<String, int> get getPreferences {
    return preferences;
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

  void setUseICO(bool value) {
    useICO = value;
  }

  void setPreferredFinancial(String value) {
    preferredFinancial = value;
  }

  void setpreferredFramewok(String value) {
    preferredFramewok = value;
  }
  void setOwnerUID(String uid) {
    ownerUID = uid;
  }

  void setPrefernces(Map<String, int> nPreferences) {
    preferences = nPreferences;
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'name': name,
    'country': country,
    'bannerPicUrl': bannerPicURL,
    'profilePicUrl': profilePicUrl,
    'ownerUID': ownerUID,
    'useICO': useICO,
    'preferredFinancial': preferredFinancial,
    'preferredFramewok': preferredFramewok,
    'preferences': preferences,
  };
}