import 'package:unicorn/controllers/api_controller.dart';
import 'package:unicorn/models/country.dart';
import 'package:unicorn/models/trend.dart';
import 'package:unicorn/models/industry.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Api {

  ApiController mApi = ApiController();

  Future<List<Country>> getCountries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mCountriesCache = prefs.getString('countries') ?? '';
    if (mCountriesCache == '') {
      final response = await mApi.fetchCountries();
      await prefs.setString('countries', json.encode(response));
      List countries = response['data'];
      List<Country> mCountries = <Country>[];
      for (int i = 0; i < countries.length; i++) {
        mCountries.add(new Country(name: countries[i]));
      }
      return mCountries;
    } else {
      final response = json.decode(mCountriesCache);
      List countries = response['data'];
      List<Country> mCountries = <Country>[];
      for (int i = 0; i < countries.length; i++) {
        mCountries.add(new Country(name: countries[i]));
      }
      return mCountries;
    }
  }

  Future<List<Trend>> getTrends(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mTrendsCache = prefs.getString('trend' + country) ?? '';
    if (mTrendsCache == '') {
      final response = await mApi.fetchTrends(country);
      await prefs.setString('trend' + country, json.encode(response));
      var tempTrends = response['data'].keys;
      List trends = [];
      for (var mTrend in tempTrends) trends.add(mTrend);
      List<Trend> mTrends = <Trend>[];
      for (int i = 0; i < trends.length; i++) {
        var mTrend = response['data'][trends[i]];
        mTrends.add(new Trend(name: trends[i], funding: mTrend['funding'], startups: mTrend['startups']));
      }
      return mTrends;
    } else {
      final response = json.decode(mTrendsCache);
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
  }

  Future<List<Industry>> getInversion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mInversionCache = prefs.getString('inversion') ?? '';
    if (mInversionCache == '') {
      final response = await mApi.fetchInversion();
      await prefs.setString('inversion', json.encode(response));
      var tempIndustries = response['data'].keys;
      List industries = [];
      for (var mIndustry in tempIndustries) industries.add(mIndustry);
      List<Industry> mIndustries = <Industry>[];
      for (int i = 0; i < industries.length; i++) {
        var mIndustry = response['data'][industries[i]];
        mIndustries.add(new Industry(name: industries[i], funding: mIndustry['funding'], startups: mIndustry['startups']));
      }
      return mIndustries;
    } else {
      final response = json.decode(mInversionCache);
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
}
