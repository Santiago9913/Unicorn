import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiController {

  static const apiHost = "https://unicornm.herokuapp.com";
  static const trendsEndpoint = "/api/trending/country/";
  static const countriesEndpoint = "/api/country/all";
  static const industriesEndpoint = "/api/inversion/all";

  dynamic fetchCountries() async {
    final response = await http.get(Uri.parse(apiHost + countriesEndpoint));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load countries.');
    }
  }

  dynamic fetchTrends(String country) async {
    final response = await http.get(Uri.parse(apiHost + trendsEndpoint + country));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load trends.');
    }
  }

  dynamic fetchInversion() async {
    final response = await http.get(Uri.parse(apiHost + industriesEndpoint));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load inversions.');
    }
  }
}
