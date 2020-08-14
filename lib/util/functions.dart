import 'package:agent_second/models/daily_log.dart';
import 'package:agent_second/providers/export.dart';
import 'package:dio/dio.dart';
import '../constants/config.dart';
import 'package:location/location.dart';


import 'service_locator.dart';

Future<List<String>> getLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  final List<String> locaion = <String>[];
  final Location location = Location();
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return locaion;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return locaion;
    }
  }

  locationData = await location.getLocation();
  locaion.add(locationData.latitude.toString());
  locaion.add(locationData.longitude.toString());
  return locaion;
}

Future<bool> get updateLocation async {
  bool res;

  config.locationController.text = "getting your location...";

  final List<String> loglat = await getLocation();
  if (loglat.isEmpty) {
    res = false;
  } else {
    config.lat = double.parse(loglat.elementAt(0));
    config.long = double.parse(loglat.elementAt(1));
    res = true;
  }
  return res;
}

Future<void> setDayLog(Response<dynamic> response) async {
 // final Response<dynamic> response = await dio.get<dynamic>("day_log");
     final DailyLog daielyLog = DailyLog.fromJson(response.data);
    getIt<GlobalVars>().setDailyLog(
        daielyLog.tBeneficiariryCount.toString(),
        daielyLog.orderCount.toString(),
        daielyLog.totalOrderCount.toString(),
        daielyLog.returnCount.toString(),
        daielyLog.totalReturnCount.toString(),
        daielyLog.collectionCount.toString(),
        daielyLog.totalCollectionCount.toString());
}
