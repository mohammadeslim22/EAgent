import 'package:agent_second/providers/auth.dart';
import 'package:agent_second/providers/counter.dart';
import 'package:agent_second/providers/language.dart';
import 'package:agent_second/providers/global_variables.dart';
import 'package:agent_second/services/navigationService.dart';
import 'package:agent_second/ui/auth/login_screen.dart';
import 'package:agent_second/ui/home.dart';
import 'package:agent_second/util/data.dart';
import 'package:agent_second/util/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/route.dart';
import 'constants/themes.dart';
import 'localization/localization_delegate.dart';
import 'util/service_locator.dart';
import 'package:agent_second/providers/order_provider.dart';

// import 'package:flutter/scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  dioDefaults();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider<Language>(
          create: (_) => Language(),
        ),
        ChangeNotifierProvider<MyCounter>(
          create: (_) => MyCounter(),
        ),
        ChangeNotifierProvider<GlobalVars>.value(
          value: getIt<GlobalVars>(),
        ),
        ChangeNotifierProvider<OrderListProvider>.value(
          value: getIt<OrderListProvider>(),
        ),
      ],
      child: MyApp(),
    ),
  );

  dioDefaults();
  await data.getData('authorization').then<dynamic>((dynamic auth) {
    print(auth);
    if (auth == null) {}
    dio.options.headers['authorization'] = '$auth';
  });

  // data.getData("lat").then((String value) {
  //   config.lat = double.parse(value);
  // });
  // data.getData("long").then((String value) {
  //   config.long = double.parse(value);
  // });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Language lang = Provider.of<Language>(context);

    return MaterialApp(
        navigatorKey: getIt<NavigationService>().navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DemoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('ar'),
          Locale('en'),
        ],
        locale: lang.currentLanguage,
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }

          for (final Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          // SchedulerBinding.instance.addPostFrameCallback(
          //   (_) => lang.setLanguage(supportedLocales.first),
          // );

          return supportedLocales.first;
        },
        theme: mainThemeData(),
        onGenerateRoute: onGenerateRoute,
        home: const Home());
  }
}
