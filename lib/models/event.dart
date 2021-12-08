class Event {

  String name;
  String date;
  String description;
  String timeStart;
  String timeEnd;

  Event({
    required this.name,
    required this.date,
    required this.description,
    required this.timeStart,
    required this.timeEnd
  });

  get getName {
    return name;
  }

  get getDate {
    return date;
  }

  get getDescription {
    return description;
  }

  get getTimeStart {
    return timeStart;
  }

  get getTimeEnd {
    return timeEnd;
  }

  void setName(String nName) {
    name = nName;
  }

  void setDate(String nDate) {
    date = nDate;
  }

  void setDescription(String nDescription) {
    description = nDescription;
  }

  void setTimeStart(String nTimeStart) {
    timeStart = nTimeStart;
  }

  void setTimeEnd(String nTimeEnd) {
    timeEnd = nTimeEnd;
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'name': name,
    'date': date,
    'description': description,
    'timeStart': timeStart,
    'timeEnd': timeEnd
  };

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
        name: map["name"],
        date: map["date"],
        description: map["description"],
        timeStart: map["timeStart"],
        timeEnd: map["timeEnd"]
    );
  }
}