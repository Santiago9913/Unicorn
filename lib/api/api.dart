import 'package:unicorn/controllers/api_controller.dart';
import 'package:unicorn/models/country.dart';
import 'package:unicorn/models/trend.dart';
import 'package:unicorn/models/industry.dart';

class Api {

  ApiController mApi = ApiController();

  Future<List<Country>> getCountries() async {
    final response = await mApi.fetchCountries();
    List countries = response['data'];
    List<Country> mCountries = <Country>[];
    for (int i = 0; i < countries.length; i++) {
      mCountries.add(new Country(name: countries[i]));
    }
    return mCountries;
  }

  Future<List<Trend>> getTrends(String country) async {
    final response = await mApi.fetchTrends(country);
    var tempTrends = response['data'].keys;
    List trends = [];
    for (var mTrend in tempTrends) trends.add(mTrend);
    List<Trend> mTrends = <Trend>[];
    for (int i = 0; i < trends.length; i++) {
      var mTrend = response['data'][trends[i]];
      mTrends.add(new Trend(name: trends[i], funding: mTrend['funding'], startups: mTrend['startups']));
    }
    return mTrends;
  }

  Future<List<Industry>> getInversion() async {
    final response = await mApi.fetchInversion();
    var tempIndustries = response['data'].keys;
    List industries = [];
    for (var mIndustry in tempIndustries) industries.add(mIndustry);
    List<Industry> mIndustries = <Industry>[];
    for (int i = 0; i < industries.length; i++) {
      var mIndustry = response['data'][industries[i]];
      mIndustries.add(new Industry(name: industries[i], funding: mIndustry['funding'], startups: mIndustry['startups']));
    }
    return mIndustries;
  }
}
