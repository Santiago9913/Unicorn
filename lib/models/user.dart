class User {
  String? name;
  String? secondName;
  String? email;

  User({
    required this.name,
    required this.secondName,
    required this.email,
  });

  String get getName {
    return name!;
  }

  String get getSecondName {
    return secondName!;
  }

  String get getEmail {
    return email!;
  }
}
