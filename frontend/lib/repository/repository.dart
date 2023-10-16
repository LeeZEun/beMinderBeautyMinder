import 'package:beautyminder/repository/datasource/datasource.dart';
import 'package:beautyminder/repository/repository.dart';
import 'package:get_it/get_it.dart';

export 'todo_repository.dart';

class AppRepository {
  static register() {
    GetIt.I.registerSingleton<TodoRepository>(
        TodoRepository(GetIt.I.get<TodoDatasource>()));
  }
}
