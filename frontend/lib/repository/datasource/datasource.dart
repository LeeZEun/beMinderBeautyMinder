import 'package:beautyminder/repository/datasource/datasource.dart';
import 'package:get_it/get_it.dart';

export 'interface/interface.dart';
export 'local/local.dart';

class AppDatasource {
  static register() {
    GetIt.I.registerSingleton<TodoDatasource>(TodoLocalDatasource());
  }
}
