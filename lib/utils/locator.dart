import 'package:prepaud/database/databese_service.dart';
import 'package:prepaud/main.dart';


initLocator() {
  locator.registerFactory<DatabaseService>(() => DatabaseService());
}