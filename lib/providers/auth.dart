import 'dart:async';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/util/data.dart';
import 'package:agent_second/util/dio.dart';
import 'package:agent_second/widgets/custom_toast_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:cron/cron.dart';
import 'package:provider/provider.dart';
import 'package:agent_second/providers/global_variables.dart';

class Auth with ChangeNotifier {
  Auth();
  Future<dynamic> login(
      String usernametext, String passwordText, BuildContext context) async {
    await dio.post<dynamic>("login", data: <String, dynamic>{
      "username": usernametext.toString().trim(),
      "password": passwordText
    }).then<dynamic>((Response<dynamic> value) async {
      print("status code: ${value.statusCode}");
      if (value.statusCode == 422) {
        return value.data['errors'];
      }

      if (value.statusCode == 200) {
        print("in login auth method ${value.data}");
        if (value.data != "fail") {
          await data.setData(
              "authorization", "Bearer ${value.data['api_token']}");
          dio.options.headers['authorization'] =
              'Bearer ${value.data['results']}';
          data.setData(
              "verchil_id", value.data['agent']['vehicle_id'].toString());
          data.setData("agent_id", value.data['id'].toString());
          data.setData("agent_name", value.data['username'].toString());
          data.setData("agent_email", value.data['email'].toString());
          final GlobalVars globalVarsProv =
              Provider.of<GlobalVars>(context, listen: false);
          cron.schedule(Schedule.parse('*/1 * * * *'), () async {
            print("wahat time is it ? ");
            globalVarsProv.incrementTimeSinceLogin();
          });
          Navigator.pushNamed(context, '/Home', arguments: <String, dynamic>{});
        } else {
          showToastWidget(
              IconToastWidget.fail(msg: trans(context, 'invalid_credentals')),
              context: context,
              position: StyledToastPosition.center,
              animation: StyledToastAnimation.scale,
              reverseAnimation: StyledToastAnimation.fade,
              duration: const Duration(seconds: 4),
              animDuration: const Duration(seconds: 1),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linear);
        }
      } else {}
    });
  }

  Map<String, dynamic> user;
  StreamSubscription<dynamic> userAuthSub;

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

  bool get isAuthenticated {
    return user != null;
  }

  void signInAnonymously() {}

  void signOut() {}
}
