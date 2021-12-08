import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';

class HiveController {
  static var imagesBox = Hive.box('imagesBox');
  static var eventsBox = Hive.box('eventsBox');

  static storeImage(String name, File file) async {
    await Hive.openBox("imagesBox");
    Uint8List fileAsString = file.readAsBytesSync();
    imagesBox.put(name, fileAsString);
  }

  static Future<Uint8List> retrieveImage(String name) async {
    await Hive.openBox("imagesBox");
    Uint8List imageDecoded = await imagesBox.get(name);
    return imageDecoded;
  }

  static storeEvents(String events) async {
    await Hive.openBox("eventsBox");
    eventsBox.put("events", events);
  }

  static Future<List<dynamic>> retrieveEvents() async {
    await Hive.openBox("eventsBox");
    var events = await eventsBox.get("events");
    return events != null ? json.decode(events) : [];
  }
}
