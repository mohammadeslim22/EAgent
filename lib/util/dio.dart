import 'package:agent_second/providers/export.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/config.dart';

String token;

BaseOptions options = BaseOptions(
  baseUrl: config.baseUrl,
  // connectTimeout: 10000,
  // receiveTimeout: 300000,
  headers: <String, String>{
    'X-Requested-With': 'XMLHttpRequest',
    'Accept': 'application/json',
    'authorization': ''
  },
  followRedirects: false,
  validateStatus: (int status) => status < 501,
);

Response<dynamic> response;

Dio dio = Dio(options);

void dioDefaults() {
  // dio.options.headers['authorization'] = 'Bearer ${config.token}';
  dio.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    // Do something before request is sent
    // options.queryParameters.addAll(<String, String>{
    //   'latitude': config.lat.toString(),
    //   'longitude': config.long.toString()
    // });
    return options;
    // If you want to resolve the request with some custom data，
    // you can return a `Response` object or return `dio.resolve(data)`.
    // If you want to reject the request with a error message,
    // you can return a `DioError` object or return `dio.reject(errMsg)`
  }, onResponse: (Response<dynamic> response) async {
    print("status code: ${response.statusCode}");
    // print("error : ${response.realUri.toString()}");
    if (response.statusCode == 200) {
   //   Fluttertoast.showToast(msg: "response.statusCode ${response.statusCode}  ${response.data}",toastLength: Toast.LENGTH_SHORT);
    }else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg:"Login please");
      getIt<NavigationService>().navigateTo('/login',null);
    }
    return response; // continue
  }, onError: (DioError e) async {
    print(e.message);
    // Do something with response error
    return e; //continue
  }));
}
