import 'package:get_it/get_it.dart';
import 'package:repository_pattern/services/api_services/api_repository.dart';
import 'package:repository_pattern/services/api_services/firebase_service.dart';

final locator = GetIt.instance;
final firebaseService = locator<ApiRepository>();
void setupLocator() {
  locator.registerLazySingleton<ApiRepository>(
    () => FirebaseService(),
  ); //firebase buradan değişiyor. MysqlService yaz diğer yerden alır
}
