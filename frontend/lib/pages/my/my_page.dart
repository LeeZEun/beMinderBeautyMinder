import 'package:beautyminder/bloc/cosmetic/cosmetic_state.dart';
import 'package:beautyminder/bloc/user/user_bloc.dart';
import 'package:beautyminder/bloc/user/user_event.dart';
import 'package:beautyminder/bloc/user/user_state.dart';
import 'package:beautyminder/pages/my/my_review_page.dart';
import 'package:beautyminder/services/cosmetic_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/cosmetic/cosmetic_bloc.dart';
import '../../bloc/cosmetic/cosmetic_event.dart';
import '../../dto/cosmetic_model.dart';
import '../../dto/user_model.dart';
import 'widgets/notification_setting_dialog.dart';
import '../../utils/Utils.dart';
import '../../widget/commonAppBar.dart';
import '../../widget/commonBottomNavigationBar.dart';
import 'package:beautyminder/pages/my/favorite_cosmetic_list_page.dart';
import 'package:beautyminder/pages/my/user_info_page.dart';
import 'package:beautyminder/pages/my/widgets/arrow_icon.dart';
import 'package:beautyminder/pages/my/widgets/my_divider.dart';
import 'package:beautyminder/pages/my/widgets/my_page_header.dart';

import '../todo/widgets/pop_up.dart';

class MyPageRoute extends MaterialPageRoute {
  MyPageRoute()
      : super(
          builder: (context) => MultiBlocProvider(
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
        );
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, userState) {
          if (userState is UserError) {
            Fluttertoast.showToast(
              msg: userState.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
        builder: (context, userState) {
          if (userState is UserInitial) {
            return const Center(
                child: CircularProgressIndicator(strokeWidth: 2));
          } else if (userState is UserLoaded) {
            return BlocConsumer<CosmeticBloc, CosmeticState>(
              listener: (context, cosmeticState) {
                if (cosmeticState is CosmeticError) {
                  Fluttertoast.showToast(
                    msg: cosmeticState.message,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              builder: (context, cosmeticState) {
                if (cosmeticState is CosmeticInitial) {
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2));
                } else if (cosmeticState is CosmeticLoaded) {
                  return MyPageBody(user: userState.user, cosmetics: cosmeticState.cosmetics,);
                } else {
                  return const Center(child: Text('error'));
                }
              }
            );
          } else {
            return Center(child: Text('error'));
          }
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            commonOnTapBottomNavigationBar(index, _currentIndex, context);
          }),
    );
  }
}

class MyPageBody extends StatelessWidget {
  final User user;
  final List<Cosmetic> cosmetics;

  const MyPageBody({super.key, required this.user, required this.cosmetics});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const MyPageHeader('마이페이지'),
            const SizedBox(height: 20),
            MyPageProfile(nickname: user.nickname ?? ""),
            const SizedBox(height: 20),
            const MyDivider(),
            MyPageMenu(title: '바우만 피부 테스트 결과', onTap: () {
              
            }),
            MyPageMenu(title: '퍼스널 피부 테스트 결과', onTap: () {
              
            }),
            MyPageMenu(title: '즐겨찾기 해둔 제품', onTap: () {
              Navigator.of(context).push(FavoriteCosmeticListRoute());
            }),
            MyPageMenu(title: '내가 쓴 리뷰', onTap: () {
              Navigator.of(context).push(MyReviewRoute(user.nickname ?? "", user.profileImage ?? ""));
            }),
            const SizedBox(height: 20),
          ])
        ]));
  }
}

class MyPageProfile extends StatelessWidget {
  final String nickname;

  const MyPageProfile({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/profile.png'),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  nickname,
                  style:
                      const TextStyle(fontSize: 15, color: Color(0xFF585555)),
                  textAlign: TextAlign.left,
                ),
                IconButton(
                    icon: arrowIcon(const Color(0xFFFE9738)),
                    onPressed: () {
                      Navigator.of(context).push(UserInfoRoute());
                    }),
              ])
            ],
          ),
        )
      ],
    );
  }
}

class MyPageMenu extends StatelessWidget {

  final String title;
  VoidCallback? onTap;

  MyPageMenu({super.key,required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, color: Color(0xFF868383)),
              textAlign: TextAlign.left,
            ),
            IconButton(
                icon: arrowIcon(const Color(0xFFFE9738)),
                onPressed: () {
                    onTap?.call();
                })
          ],
        )
    );
  }
}
