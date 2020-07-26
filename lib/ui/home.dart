import 'dart:async';
import 'dart:convert' as Convert;
import 'dart:typed_data';
import 'dart:ui';
import 'package:agent_second/constants/config.dart';
import 'package:agent_second/models/daily_log.dart';
import 'package:agent_second/providers/global_variables.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/util/dio.dart';
import 'package:agent_second/widgets/global_drawer.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:agent_second/models/ben.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<BeneficiariesModel> getBenData() async {
    //final GlobalVars globalVarsProv = Provider.of<GlobalVars>(context);
    final Response<dynamic> response = await dio.get<dynamic>("beneficaries");
    print("wooww?  ${response.data}");
    await Future<void>.delayed(const Duration(seconds: 3), () {});
    getIt<GlobalVars>().setBens(BeneficiariesModel.fromJson(response.data));
    // globalVarsProv.beneficiaries = BeneficiariesModel.fromJson(response.data);

    return getIt<GlobalVars>().beneficiaries;
  }

  @override
  Widget build(BuildContext context) {
    if (config.looded) {
      return const DashBoard();
    }
    {
      return FutureBuilder<BeneficiariesModel>(
        future: getBenData(),
        builder:
            (BuildContext ctx, AsyncSnapshot<BeneficiariesModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            config.looded = true;
            return const DashBoard();
          } else {
            return SplashScreen();
          }
        },
      );
    }
  }
}

class DashBoard extends StatefulWidget {
  const DashBoard({Key key, this.long, this.lat}) : super(key: key);
  final double long;
  final double lat;
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  StreamSubscription<dynamic> getPositionSubscription;
  GoogleMapController mapController;
  Location location = Location();
  double lat;
  double long;
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    lat = widget.lat ?? 25.063054;
    long = widget.long ?? 55.170010;
    getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    getPositionSubscription?.cancel();
  }

  Widget card(String picPath, String header, Widget widget) {
    return Container(
      width: 206,
      child: Card(
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SvgPicture.asset(
                  picPath,
                  width: 120.0,
                  height: 120.0,
                ),
                const SizedBox(height: 12),
                Text(header, style: styles.underHead),
                const SizedBox(height: 12),
                widget
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the App'),
            actionsOverflowButtonSpacing: 50,
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    // serviceEnabled = await location.serviceEnabled();
    // if (!serviceEnabled) {
    // } else {
    //   permissionGranted = await location.hasPermission();
    //   if (permissionGranted == PermissionStatus.denied) {
    //   } else {
    //     _animateToUser();
    //   }
    // }
    serviceEnabled = await location.serviceEnabled();
    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
    } else {
      if (!serviceEnabled) {
      } else {
        _animateToUser();
      }
    }
  }

  DailyLog daielyLog;
  Future<void> getUserData() async {
    final Response<dynamic> response = await dio.get<dynamic>("day_log");

    print('hello world ${response.data}');
    daielyLog = DailyLog.fromJson(Convert.jsonDecode(response.data.toString()));

    getIt<GlobalVars>().setDailyLog(
        daielyLog.tBeneficiariryCount.toString(),
        daielyLog.orderCount.toString(),
        daielyLog.totalOrderCount.toString(),
        daielyLog.returnCount.toString(),
        daielyLog.totalReturnCount.toString(),
        daielyLog.collectionCount.toString(),
        daielyLog.totalCollectionCount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text("Altariq"), centerTitle: true),
            drawer: GlobalDrawer(sourceContext: context),
            body: Consumer<GlobalVars>(
              builder: (BuildContext context, GlobalVars golbalValues,
                  Widget child) {
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        card(
                            'assets/images/remain_bin.svg',
                            trans(context, 'remain_transaction'),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.orange,
                                )),
                                child: Text(golbalValues.benRemaining,
                                    style: styles.redstyle))),
                        card(
                          'assets/images/order_transaction.svg',
                          trans(context, 'order_transaction'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.green[200],
                                  )),
                                  child: Text(golbalValues.orderscount,
                                      style: styles.greenstyle)),
                              const SizedBox(
                                width: 12,
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: const Color(0xFF008585),
                                  )),
                                  child: Text(golbalValues.orderTotal,
                                      style: styles.greenstyle))
                            ],
                          ),
                        ),
                        card(
                          'assets/images/return_transaction.svg',
                          trans(context, 'return_transaction'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.purple,
                                  )),
                                  child: Text(golbalValues.returnscount,
                                      style: styles.purplestyle)),
                              const SizedBox(width: 12),
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: const Color(0xFF008585),
                                  )),
                                  child: Text(golbalValues.returnTotal,
                                      style: styles.purplestyle))
                            ],
                          ),
                        ),
                        card(
                            'assets/images/collection.svg',
                            trans(context, 'collection_transaction'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.blue,
                                    )),
                                    child: Text(golbalValues.collectionscount,
                                        style: styles.darkbluestyle)),
                                const SizedBox(
                                  width: 12,
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: const Color(0xFF008585),
                                    )),
                                    child: Text(golbalValues.collectionTotal,
                                        style: styles.darkbluestyle))
                              ],
                            )),
                        card(
                            'assets/images/login_time.svg',
                            trans(context, 'time_since_login'),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.green,
                                )),
                                child: Text(golbalValues.timeSinceLogin,
                                    style: styles.darkgreenstyle))),
                        card(
                            'assets/images/last_trip_time.svg',
                            trans(context, 'time_since_last_trip'),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: const Color(0xFF00158F),
                                )),
                                child:
                                    Text("00:48:33", style: styles.bluestyle))),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          GoogleMap(
                            onMapCreated: _onMapCreated,
                            mapType: MapType.normal,
                            markers: Set<Marker>.of(markers.values),
                            initialCameraPosition: CameraPosition(
                              target: LatLng(lat, long),
                              zoom: 13,
                            ),
                            onCameraMove: (CameraPosition pos) {
                              setState(() {
                                lat = pos.target.latitude;
                                long = pos.target.longitude;
                              });
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 69),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                width: 40,
                                height: 40,
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(6),
                                    onTap: () {},
                                    child: GestureDetector(
                                      child: Center(
                                        child: Icon(
                                          Icons.my_location,
                                          color: const Color.fromARGB(
                                              1023, 150, 150, 150),
                                        ),
                                      ),
                                      onTap: () async {
                                        serviceEnabled =
                                            await location.serviceEnabled();
                                        if (!serviceEnabled) {
                                          serviceEnabled =
                                              await location.requestService();
                                          if (!serviceEnabled) {
                                          } else {
                                            permissionGranted =
                                                await location.hasPermission();
                                            if (permissionGranted ==
                                                PermissionStatus.denied) {
                                              permissionGranted = await location
                                                  .requestPermission();
                                              if (permissionGranted ==
                                                  PermissionStatus.granted) {
                                                _animateToUser();
                                              }
                                            } else {
                                              _animateToUser();
                                            }
                                          }
                                        } else {
                                          permissionGranted =
                                              await location.hasPermission();
                                          if (permissionGranted ==
                                              PermissionStatus.denied) {
                                            permissionGranted = await location
                                                .requestPermission();
                                            if (permissionGranted ==
                                                PermissionStatus.granted) {
                                              _animateToUser();
                                            }
                                          } else {
                                            _animateToUser();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void _addMarker(Marker marker) {
    final MarkerId markerId = MarkerId('current_location');

    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<void> _animateToUser() async {
    try {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/images/logo.jpg', 100);
      await location.getLocation().then((LocationData value) {
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 13,
        )));
        getPositionSubscription =
            location.onLocationChanged.listen((LocationData value) {
          final Marker marker = Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(value.latitude, value.longitude),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          );
          _addMarker(marker);
        });
        setState(() {
          lat = value.latitude;
          long = value.longitude;
        });
      });
    } catch (e) {
      return;
    }
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // static Future<T> pushReplacement<T extends Object, TO extends Object>(
  //     BuildContext context, Route<T> newRoute,
  //     {TO result}) {
  //   return Navigator.of(context)
  //       .pushReplacement<T, TO>(newRoute, result: result);
  // }

  double width = 200;
  double hihg = 200;
  @override
  void initState() {
    super.initState();

    Future<void>.delayed(const Duration(seconds: 0), () {
      setState(() {
        width = 250;
        hihg = 250;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Stack(
        children: const <Widget>[
          FlareActor("assets/images/LiquidDownloaddemo.flr",
              alignment: Alignment.center,
              fit: BoxFit.cover,
              animation: "Demo"),
        ],
      ),
    );
  }
}
