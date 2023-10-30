import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cosmetic/cosmetic_bloc.dart';
import '../bloc/cosmetic/cosmetic_event.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../pages/home_page.dart';
import '../pages/hot_page.dart';
import '../pages/my/my_page.dart';
import '../pages/pouch_page.dart';
import '../pages/todo/todo_page.dart';

void commonOnTapBottomNavigationBar(int index, int currentIndex, BuildContext context) {
  if (index == currentIndex) {
    return;
  }
  // 페이지 전환 로직 추가
  if (index == 0) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HotPage()));
  } else if (index == 1) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PouchPage()));
  } else if (index == 2) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomePage()));
  } else if (index == 3) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const TodoPage()));
  } else if (index == 4) {
    Navigator.of(context).push(MyPageRoute());
  }
}