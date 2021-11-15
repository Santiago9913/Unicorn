import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unicorn/controllers/firebase_storage_controller.dart';

class LocationController {
  static Future<int> getPagesInMyLocation(String location) async {
    QuerySnapshot obj = await FirebaseStorageController.getPagesInMyLocation(location);
    return obj.size;
  }

  
  static Future<String> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Position pos = await Geolocator.getCurrentPosition();
      String lat = pos.latitude.toString();
      String lon = pos.longitude.toString();
      return "$lat,$lon";
    }
    return "";
  }
}