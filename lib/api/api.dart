import 'package:flutter/foundation.dart';
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
      mCountries = await compute(getCountriesIsolate, countries);
      return mCountries;
    } else {
      final response = json.decode(mCountriesCache);
      List countries = response['data'];
      List<Country> mCountries = <Country>[];
      mCountries = await compute(getCountriesIsolate, countries);
      return mCountries;
    }
  }

  Future<List<Trend>> getTrends(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mTrendsCache = prefs.getString('trend' + country) ?? '';
    if (mTrendsCache == '') {
      final response = await mApi.fetchTrends(country);
      await prefs.setString('trend' + country, json.encode(response));
      List<Trend> mTrends = <Trend>[];
      mTrends = await compute(getTrendsIsolate, response);
      return mTrends;
    } else {
      final response = json.decode(mTrendsCache);

      List<Trend> mTrends = <Trend>[];

      mTrends = await compute(getTrendsIsolate, response);
      return mTrends;
    }
  }

  Future<List<Industry>> getInversion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mInversionCache = prefs.getString('inversion') ?? '';
    if (mInversionCache == '') {
      final response = await mApi.fetchInversion();
      await prefs.setString('inversion', json.encode(response));

      List<Industry> mIndustries = <Industry>[];

      mIndustries = await compute(getInversionsIsolate, response);
      return mIndustries;
    } else {
      final response = json.decode(mInversionCache);

      List<Industry> mIndustries = <Industry>[];

      mIndustries = await compute(getInversionsIsolate, response);
      return mIndustries;
    }
  }
}

List<Country> getCountriesIsolate(List data) {
  List<Country> mCountries = <Country>[];
  for (int i = 0; i < data.length; i++) {
    mCountries.add(new Country(name: data[i]));
  }
  return mCountries;
}

List<Trend> getTrendsIsolate(dynamic response) {
  var tempTrends = response['data'].keys;
  List trends = [];
  for (var mTrend in tempTrends) {
    trends.add(mTrend);
  }
  List<Trend> mTrends = <Trend>[];
  for (int i = 0; i < trends.length; i++) {
    var mTrend = response['data'][trends[i]];
    mTrends.add(Trend(
        name: trends[i],
        funding: mTrend['funding'],
        startups: mTrend['startups']));
  }
  return mTrends;
}

List<Industry> getInversionsIsolate(dynamic response) {
  var tempIndustries = response['data'].keys;
  List industries = [];
  for (var mIndustry in tempIndustries) {
    industries.add(mIndustry);
  }
  List<Industry> mIndustries = <Industry>[];
  for (int i = 0; i < industries.length; i++) {
    var mIndustry = response['data'][industries[i]];
    mIndustries.add(Industry(
        name: industries[i],
        funding: mIndustry['funding'],
        startups: mIndustry['startups']));
  }
  return mIndustries;
}
