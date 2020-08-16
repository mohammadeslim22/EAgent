import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/providers/export.dart';
import 'package:agent_second/util/data.dart';
import 'package:agent_second/util/service_locator.dart';
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
                  child: SvgPicture.asset(
                    'assets/images/company_logo.svg',
                    width: 120.0,
                    height: 120.0,
                  ),
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
                  widget.sourceContext, "/Home", (_) => false);
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
              final double x = MediaQuery.of(context).size.width;
              Navigator.pushNamedAndRemoveUntil(widget.sourceContext,
                  "/Agent_Orders", (Route<dynamic> r) => r.isFirst,
                  arguments: <String, dynamic>{"expand": true,"width":x });
            },
            title: Text(trans(context, "stock_transaction")),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(widget.sourceContext, "/items",
                  (Route<dynamic> r) => r.isFirst);
            },
            title: Text(trans(context, "items")),
          ),
        ],
      ),
    );
  }
}
