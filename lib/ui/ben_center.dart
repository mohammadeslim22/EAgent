import 'dart:async';
import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/ben.dart';
import 'package:agent_second/models/collection.dart';
import 'package:agent_second/models/transactions.dart';
import 'package:agent_second/providers/export.dart';
import 'package:agent_second/providers/transaction_provider.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:intl/intl.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BeneficiaryCenter extends StatefulWidget {
  const BeneficiaryCenter({Key key, this.long, this.lat, this.ben})
      : super(key: key);
  final double long;
  final double lat;
  final Ben ben;
  @override
  _BeneficiaryCenterState createState() => _BeneficiaryCenterState();
}

class _BeneficiaryCenterState extends State<BeneficiaryCenter> {
  Ben ben;
  Transactions benTrans;
  List<MiniItems> items;
  Transaction transaction;
  Collections collection;
  int indexedStack;
  Widget noItemFound;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
      } else {
        // _animateToUser();
      }
    }
  }

  StreamSubscription<dynamic> getPositionSubscription;
  GoogleMapController mapController;
  Location location = Location();
  double lat;
  double long;
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  void initState() {
    super.initState();
    lat = widget.lat ?? 25.063054;
    long = widget.long ?? 55.170010;
    ben = widget.ben;
    billIsOn = true;
    indexedStack = 0;
    noItemFound = Container(
      width: 400,
      height: 350,
      child: const FlareActor("assets/images/empty.flr",
          alignment: Alignment.center, fit: BoxFit.fill, animation: "default"),
    );
    getIt<TransactionProvider>().pagewiseCollectionController =
        PagewiseLoadController<dynamic>(
            pageSize: 15,
            pageFuture: (int pageIndex) async {
              return getIt<TransactionProvider>()
                  .getCollectionTransactions(pageIndex, ben.id);
            });
    getIt<TransactionProvider>().pagewiseOrderController =
        PagewiseLoadController<dynamic>(
            pageSize: 15,
            pageFuture: (int pageIndex) async {
              return getIt<TransactionProvider>()
                  .getOrdersTransactions(pageIndex, ben.id);
            });
    getIt<TransactionProvider>().pagewiseReturnController =
        PagewiseLoadController<dynamic>(
            pageSize: 15,
            pageFuture: (int pageIndex) async {
              return getIt<TransactionProvider>()
                  .getReturnTransactions(pageIndex, ben.id);
            });
  }

  @override
  void dispose() {
    super.dispose();
    getPositionSubscription?.cancel();
  }

  bool billIsOn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "altariq")),
        centerTitle: true,
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(trans(context, "ben_center"),
                    style: styles.mywhitestyle),
              ),
            ],
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person_outline,
                                  color: colors.blue, size: 40),
                              const SizedBox(width: 16),
                              Text(ben.name, style: styles.beneficiresNmae)
                            ],
                          ),
                          const SizedBox(width: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.location_on,
                                  color: colors.blue, size: 30),
                              const SizedBox(width: 16),
                              Text(ben.address, style: styles.underHeadgray)
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 64),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.call, color: colors.blue, size: 30),
                              const SizedBox(width: 16),
                              Text(
                                trans(context, "mobile_number") +
                                    " : ${ben.phone}",
                                style: styles.beneficiresNmae,
                              )
                            ],
                          ),
                          const SizedBox(width: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.email, color: colors.blue, size: 30),
                              const SizedBox(width: 16),
                              Text(
                                ben.email,
                                style: styles.underHeadgray,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 160,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: colors.blue,
                          onPressed: () {
                            // getIt<OrderListProvider>().setScreensToPop(4);
                            getIt<OrderListProvider>().clearOrcerList();
                            Navigator.pushNamed(context, "/Order_Screen",
                                arguments: <String, dynamic>{
                                  "ben": ben,
                                  "isORderOrReturn": true
                                });
                          },
                          child: Text(trans(context, "order"),
                              style: styles.mywhitestyle),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Container(
                        width: 160,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: colors.red,
                          onPressed: () {
                            getIt<OrderListProvider>().clearOrcerList();
                            Navigator.pushNamed(context, "/Order_Screen",
                                arguments: <String, dynamic>{
                                  "ben": ben,
                                  "isORderOrReturn": false
                                });
                          },
                          child: Text(
                            trans(context, "return"),
                            style: styles.mywhitestyle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Container(
                        width: 160,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: colors.green,
                          onPressed: () {
                            getIt<OrderListProvider>().setScreensToPop(2);
                            Navigator.pushNamed(context, "/Payment_Screen",
                                arguments: <String, dynamic>{
                                  "transOrCollection": 2
                                });
                          },
                          child: Text(trans(context, "collection"),
                              style: styles.mywhitestyle),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(trans(context, "count") + "   ${ben.transCount}",
                          style: styles.mystyle),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: colors.green),
                            color: indexedStack == 0
                                ? Colors.green[100]
                                : Colors.transparent),
                        child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                indexedStack = 0;
                              });
                            },
                            child: SvgPicture.asset(
                                "assets/images/order_icon.svg")),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: colors.red),
                            color: indexedStack == 1
                                ? Colors.red[100]
                                : Colors.transparent),
                        child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                indexedStack = 1;
                              });
                            },
                            child: SvgPicture.asset(
                                "assets/images/return_icon.svg")),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: colors.yellow),
                            color: indexedStack == 2
                                ? Colors.yellow[100]
                                : Colors.transparent),
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              indexedStack = 2;
                            });
                          },
                          child: SvgPicture.asset(
                            "assets/images/collection_icon.svg",
                            width: 40,
                          ),
                        ),
                      ),
                      Text(trans(context, "total" "    ${ben.transTotal}"),
                          style: styles.mystyle)
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.blue[100]),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text(trans(context, "id"),
                                    style: styles.mystyle,
                                    textAlign: TextAlign.start)),
                            Expanded(
                              child: Text(trans(context, "agent"),
                                  style: styles.mystyle),
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(trans(context, "date"),
                                    style: styles.mystyle,
                                    textAlign: TextAlign.center)),
                            Expanded(
                                child: Text(trans(context, "total"),
                                    style: styles.mystyle,
                                    textAlign: TextAlign.end))
                          ],
                        ),
                      )),
                  Expanded(
                    child: IndexedStack(
                      index: indexedStack,
                      children: <Widget>[
                        SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(
                              complete: Container(),
                              waterDropColor: Colors.blue,
                            ),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = const Text("pull up load");
                                } else if (mode == LoadStatus.loading) {
                                  body = const CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = const Text("Load Failed!Click retry!");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = const Text("release to load more");
                                } else {
                                  body = const Text("No more Data");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: () async {
                              if (mounted) {
                                getIt<TransactionProvider>()
                                    .pagewiseOrderController
                                    .reset();
                                _refreshController.refreshCompleted();
                              }
                              getIt<TransactionProvider>()
                                  .pagewiseOrderController
                                  .reset();
                              _refreshController.refreshCompleted();
                            },
                            onLoading: () async {
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 1000));
                              if (mounted) {
                                setState(() {});
                                _refreshController.loadComplete();
                              }
                            },
                            child: PagewiseListView<dynamic>(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              pageLoadController: getIt<TransactionProvider>()
                                  .pagewiseOrderController,
                              loadingBuilder: (BuildContext context) {
                                return Container(
                                  width: 400,
                                  height: 400,
                                  child: const FlareActor(
                                      "assets/images/counter.flr",
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      animation: "play"),
                                );
                              },
                              //  pageSize: 15,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              itemBuilder: (BuildContext context, dynamic entry,
                                  int index) {
                                return AnimatedCard(
                                  direction: AnimatedCardDirection.left,
                                  initDelay: const Duration(milliseconds: 0),
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease,
                                  child: _transactionBuilder(
                                      context, entry as Transaction),
                                );
                              },
                              noItemsFoundBuilder: (BuildContext context) {
                                return noItemFound;
                              },
                              // pageFuture: (int pageIndex) {
                              //   return getIt<TransactionProvider>()
                              //       .getOrdersTransactions(pageIndex, ben.id);
                              // },
                            )),
                        SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(
                              complete: Container(),
                              waterDropColor: Colors.blue,
                            ),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = const Text("pull up load");
                                } else if (mode == LoadStatus.loading) {
                                  body = const CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = const Text("Load Failed!Click retry!");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = const Text("release to load more");
                                } else {
                                  body = const Text("No more Data");
                                }
                                return Container(
                                    height: 55.0, child: Center(child: body));
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: () async {
                              if (mounted) {
                                getIt<TransactionProvider>()
                                    .pagewiseReturnController
                                    .reset();
                                _refreshController.refreshCompleted();
                              }
                            },
                            onLoading: () async {
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 1000));
                              if (mounted) {
                                setState(() {});
                                _refreshController.loadComplete();
                              }
                            },
                            child: PagewiseListView<dynamic>(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              pageLoadController: getIt<TransactionProvider>()
                                  .pagewiseReturnController,

                              loadingBuilder: (BuildContext context) {
                                return Container(
                                  width: 400,
                                  height: 400,
                                  child: const FlareActor(
                                      "assets/images/counter.flr",
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      animation: "play"),
                                );
                              },
                              // pageSize: 15,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              itemBuilder: (BuildContext context, dynamic entry,
                                  int index) {
                                return AnimatedCard(
                                  direction: AnimatedCardDirection.left,
                                  initDelay: const Duration(milliseconds: 0),
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease,
                                  child: _transactionBuilder(
                                      context, entry as Transaction),
                                );
                              },
                              noItemsFoundBuilder: (BuildContext context) {
                                return noItemFound;
                              },
                              // pageFuture: (int pageIndex) {
                              //   return getIt<TransactionProvider>()
                              //       .getReturnTransactions(pageIndex, ben.id);
                              // },
                            )),
                        SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(
                              complete: Container(),
                              waterDropColor: Colors.blue,
                            ),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = const Text("pull up load");
                                } else if (mode == LoadStatus.loading) {
                                  body = const CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = const Text("Load Failed!Click retry!");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = const Text("release to load more");
                                } else {
                                  body = const Text("No more Data");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: () async {
                              if (mounted) {
                                getIt<TransactionProvider>()
                                    .pagewiseCollectionController
                                    .reset();
                                _refreshController.refreshCompleted();
                              }
                            },
                            onLoading: () async {
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 1000));
                              if (mounted) {
                                setState(() {});
                                _refreshController.loadComplete();
                              }
                            },
                            child: PagewiseListView<dynamic>(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              loadingBuilder: (BuildContext context) {
                                return Container(
                                  width: 400,
                                  height: 400,
                                  child: const FlareActor(
                                      "assets/images/counter.flr",
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      animation: "play"),
                                );
                              },
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              itemBuilder: (BuildContext context, dynamic entry,
                                  int index) {
                                return AnimatedCard(
                                  direction: AnimatedCardDirection.left,
                                  initDelay: const Duration(milliseconds: 0),
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease,
                                  child: collectionBuilder(
                                      entry as SingleCollection),
                                );
                              },
                              pageLoadController: getIt<TransactionProvider>()
                                  .pagewiseCollectionController,
                              noItemsFoundBuilder: (BuildContext context) {
                                return noItemFound;
                              },
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (billIsOn)
              Expanded(
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      padding: const EdgeInsets.only(bottom: 60),
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
                      padding: const EdgeInsets.only(left: 8.0, bottom: 69),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Material(
                            color: colors.white,
                            borderRadius: BorderRadius.circular(6),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () {},
                              child: GestureDetector(
                                child: const Center(
                                  child: Icon(
                                    Icons.my_location,
                                    color: Color.fromARGB(1023, 150, 150, 150),
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
                                        permissionGranted =
                                            await location.requestPermission();
                                        if (permissionGranted ==
                                            PermissionStatus.granted) {
                                          //  _animateToUser();
                                        }
                                      } else {
                                        //    _animateToUser();
                                      }
                                    }
                                  } else {
                                    permissionGranted =
                                        await location.hasPermission();
                                    if (permissionGranted ==
                                        PermissionStatus.denied) {
                                      permissionGranted =
                                          await location.requestPermission();
                                      if (permissionGranted ==
                                          PermissionStatus.granted) {
                                        //  _animateToUser();
                                      }
                                    } else {
                                      //   _animateToUser();
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
              )
            else
              Expanded(child: bill(items)),
            //    Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _transactionBuilder(
    BuildContext context,
    Transaction entry,
  ) {
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Share',
            color: colors.blue,
            icon: Icons.share,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Delete',
            color: colors.red,
            icon: Icons.delete,
            onTap: () {},
          ),
        ],
        child: FlatButton(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: entry.id % 2 == 1 ? Colors.blue[400] : Colors.transparent,
          onPressed: () {
            setState(() {
              items = entry.details;
              billIsOn = false;
              transaction = entry;
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(entry.id.toString(),
                      style: styles.mystyle, textAlign: TextAlign.start)),
              Expanded(
                  flex: 2, child: Text(entry.agent, style: styles.mystyle)),
              Expanded(
                  flex: 2, child: Text(entry.transDate, style: styles.mystyle)),
              Expanded(
                  child: Text(entry.amount.toString() + ".00",
                      style: styles.mystyle, textAlign: TextAlign.end))
            ],
          ),
        ));
  }

  Widget collectionBuilder(SingleCollection collection) {
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Share',
            color: colors.blue,
            icon: Icons.share,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Delete',
            color: colors.red,
            icon: Icons.delete,
            onTap: () {},
          ),
        ],
        child: FlatButton(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: collection.id % 2 == 0 ? Colors.blue[200] : Colors.transparent,
          onPressed: () {},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(collection.id.toString(),
                      style: styles.mystyle, textAlign: TextAlign.start)),
              Expanded(
                  flex: 2,
                  child: Text(collection.agent ?? "اسم المندوب هنا",
                      style: styles.mystyle)),
              Expanded(
                  flex: 2,
                  child: Text(collection.createdAt, style: styles.mystyle)),
              Expanded(
                  child: Text(collection.amount.toString() + ".00",
                      style: styles.mystyle, textAlign: TextAlign.end))
            ],
          ),
        ));
  }

  Widget bill(List<MiniItems> items) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(trans(context, "name"), style: styles.mybluestyle),
                      const SizedBox(height: 24),
                      Text(trans(context, "date"), style: styles.mybluestyle)
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(ben.name, style: styles.mystyle),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(transaction.transDate, style: styles.mystyle),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            if (!billIsOn)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                width: 130,
                height: 130,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            billIsOn = !billIsOn;
                          });
                        },
                        child: const FlareActor("assets/images/maps.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            animation: "anim"),
                      ),
                    ),
                    Text(
                      trans(context, "back_to_map"),
                      style: TextStyle(color: colors.black),
                    )
                  ],
                ),
              )
            else
              Container(),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(trans(context, 'id'),
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'product_name'),
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'quantity'),
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'unit'),
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'unit_price'),
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'total'),
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                ],
                rows: items.map((MiniItems e) {
                  return DataRow(cells: <DataCell>[
                    DataCell(Text(e.id.toString())),
                    DataCell(Text(e.item)),
                    DataCell(Text(e.quantity.toString())),
                    DataCell(Text(e.unit.toString())),
                    DataCell(Text(e.itemPrice.toString())),
                    DataCell(Text((e.itemPrice * e.quantity).toString()))
                  ]);
                }).toList(),
              )),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(trans(context, "share"), style: styles.mybluestyle),
                      const Icon(Icons.share, size: 20)
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(trans(context, "total"), style: styles.mybluestyle),
                const SizedBox(width: 12),
                Text(trans(context, transaction.amount.toString() + ".00"),
                    style: styles.mystyle),
                const SizedBox(width: 32),
              ],
            ),
          ],
        )
      ],
    );
  }
}
