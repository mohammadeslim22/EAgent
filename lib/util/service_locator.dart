import 'package:agent_second/providers/global_variables.dart';
import 'package:get_it/get_it.dart';
import '../providers/order_provider.dart';
import '../services/navigationService.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
getIt.registerLazySingleton(() => NavigationService());
getIt.registerLazySingleton(() => OrderListProvider());
getIt.registerLazySingleton(() => GlobalVars());



}