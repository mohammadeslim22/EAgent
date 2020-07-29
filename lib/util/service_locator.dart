
import 'package:get_it/get_it.dart';
import '../providers/export.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
getIt.registerLazySingleton(() => NavigationService());
getIt.registerLazySingleton(() => OrderListProvider());
getIt.registerLazySingleton(() => GlobalVars());
getIt.registerLazySingleton(() => TransactionProvider());




}