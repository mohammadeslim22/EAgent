import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/providers/export.dart';
import 'package:agent_second/util/data.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GlobalDrawer extends StatefulWidget {
  const GlobalDrawer({
    Key key,
    @required this.sourceContext,
  }) : super(key: key);
  final BuildContext sourceContext;

  @override
  _GlobalDrawerState createState() => _GlobalDrawerState();
}

class _GlobalDrawerState extends State<GlobalDrawer> {
  String agentName;

  void restoreData() {
    data.getData("agent_name").then((String value) {
      setState(() {
        agentName = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    restoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(agentName, style: styles.underHeadwhite),
                  ],
                ),
                CircleAvatar(
                  maxRadius: 55,
                  minRadius: 40,
                  child:     SvgPicture.asset(
                        'assets/images/company_logo.svg',
                        width: 120.0,
                        height: 120.0,
                      ),
                  
                  //  CachedNetworkImage(
                  //   placeholderFadeInDuration:
                  //       const Duration(milliseconds: 300),
                  //   imageUrl:
                  //       "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg",
                  //   imageBuilder:
                  //       (BuildContext context, ImageProvider imageProvider) =>
                  //           Container(
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       image: DecorationImage(
                  //           image: imageProvider,
                  //           fit: BoxFit.cover,
                  //           colorFilter: const ColorFilter.mode(
                  //               Colors.white, BlendMode.colorBurn)),
                  //     ),
                  //   ),
                  //   placeholder: (BuildContext context, String url) =>
                  //       const CircularProgressIndicator(),
                  //   errorWidget:
                  //       (BuildContext context, String url, dynamic error) =>
                  //           const Icon(Icons.error),
                  // ),
                )
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),

          ListTile(
            onTap: () {
              getIt<GlobalVars>().closeBens();

              Navigator.pushNamedAndRemoveUntil(
                  widget.sourceContext, "/Home", (_) => false
                  // arguments: <String, List<MemberShip>>{
                  //   "membershipsData": MemberShip.membershipsData
                  // }
                  );
            },
            title: Text(trans(context, "home")),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(widget.sourceContext,
                  "/Beneficiaries", (Route<dynamic> r) => r.isFirst);

            },
            title: Text(trans(context, "beneficiaries")),
          ),

          const Divider(),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(
                widget.sourceContext, "/Beneficiaries",
                // arguments: <String, List<MemberShip>>{
                //   "membershipsData": MemberShip.membershipsData
                // }
              );
            },
            title: Text(trans(context, "stock_transaction")),
          ),
          // ListTile(
          //   onTap: () {},
          //   title: Text(trans(context, "beneficiaries")),
          // ),
          // ListTile(
          //   onTap: () {},
          //   title: Text(trans(context, "home")),
          // ),
        ],
      ),
    );
  }
}
