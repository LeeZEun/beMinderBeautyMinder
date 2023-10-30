
import 'package:beautyminder/pages/my_page.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/recommend_page.dart';
import 'package:beautyminder/pages/todo/todo_page.dart';
import 'package:beautyminder/pages/todo/viewmodel/page_view_model.dart';
import 'package:beautyminder/pages/todo/viewmodel/todo_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/cosmetic/cosmetic_bloc.dart';
import 'bloc/cosmetic/cosmetic_event.dart';
import 'bloc/user/user_bloc.dart';
import 'bloc/user/user_event.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'repository/datasource/datasource.dart';

// Widget _defaultHome = WelcomePage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<PageViewModel>(create: (_) => PageViewModel()),
      ChangeNotifierProvider<TodoViewModel>(
        create: (_) => TodoViewModel()..getTodos(),
      ),
    ],
    child:  MaterialApp(
      title: 'BeautyMinder',
      theme: ThemeData(
        primaryColor: const Color(0xffffb876),
        colorScheme: const ColorScheme.light(
          primary: Color(0xffffb876),
          secondary: Color(0xffFF820E),
        ),
      ),
      // home: const LoginPage(),
      home: LoginPage(),
      routes: {
        // '/': (context) => _defaultHome,
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/recommend': (context) => const RecPage(),
        '/pouch': (context) => const PouchPage(),
        '/home': (context) => const HomePage(),
        '/todo': (context) => const TodoPage(),
        '/my': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<UserBloc>(
                  create: (context) => UserBloc()..add(FetchUsers()),
                ),
                BlocProvider<CosmeticBloc>(
                  create: (context) => CosmeticBloc()..add(FetchCosmetics()),
                ),
              ],
              child: const MyPage(),
            ),
      },
    ),
    );
  }
}
