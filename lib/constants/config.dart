import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';

class Config {
  factory Config() {
    return _config;
  }

  Config._internal();

  static final Config _config = Config._internal();

   String baseUrl = "http://edisagents.altariq.ps/public/api/v1/";
  // String baseUrl = "http://space.co.ps/joker/api/ar/v1/customer/";

  String onesignal = "bc4208c6-1-48c0-b4d5-390029a340dc"; // ca9a

  String countryCode = '+970';

  bool looded=false;
  final TextEditingController locationController = TextEditingController();
  Address first;
  Coordinates coordinates;
  List<Address> addresses;

  double lat = 0.0;
  double long = 0.0;
  String token = "";
}

final Config config = Config();
