class Industry {
  String name;
  int funding;
  int startups;

  Industry({
    required this.name,
    required this.funding,
    required this.startups,
  });

  get getName {
    return name;
  }

  get getFunding {
    return funding;
  }

  get getStartups {
    return startups;
  }

  void setContent(String nName) {
    name = nName;
  }

  void setImgUrl(int nFunding) {
    funding = nFunding;
  }

  void setDatePosted(int nStartups) {
    startups = nStartups;
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'name': name,
    'funding': funding,
    'startups': startups,
  };

  factory Industry.fromJson(String name, Map<String, dynamic> json) {
    return Industry(
      name: name,
      funding: json['funding'],
      startups: json['startups'],
    );
  }
}
