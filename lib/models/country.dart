class Country {
  String name;

  Country({
    required this.name
  });

  get getName {
    return name;
  }

  void setContent(String nName) {
    name = nName;
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'name': name
  };

  factory Country.fromJson(String name) {
    return Country(
        name: name
    );
  }
}
