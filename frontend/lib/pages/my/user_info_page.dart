import 'package:beautyminder/pages/my/user_info_modify_page.dart';
import 'package:beautyminder/pages/my/widgets/my_divider.dart';
import 'package:beautyminder/pages/my/widgets/my_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_state.dart';
import '../../dto/user_model.dart';
import '../../utils/Utils.dart';
import '../../widget/commonAppBar.dart';
import '../../widget/commonBottomNavigationBar.dart';
import '../todo/widgets/pop_up.dart';

class UserInfoRoute extends MaterialPageRoute {
  UserInfoRoute() : super(
    builder: (context) => BlocProvider<UserBloc>(
      create: (context) => UserBloc()..add(FetchUsers()),
      child: const UserInfoPage(),
    ),
  );
}

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    const int currentIndex = 4;

    return Scaffold(
      appBar: CommonAppBar(),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
        builder: (context, state) {
          if (state is UserInitial) {
            return const Center(
                child: CircularProgressIndicator(strokeWidth: 2));
          } else if (state is UserLoaded) {
            return UserInfoPageBody(user: state.user);
          } else {
            return const Center(child: Text('error'));
          }
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            commonOnTapBottomNavigationBar(index, currentIndex, context);
          }),
    );
  }
}

class UserInfoPageBody extends StatelessWidget {
  final User user;
  const UserInfoPageBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(children: [
              MyPageHeader('회원정보'),
              SizedBox(height: 20),
              UserInfoProfile(nickname: user.nickname ?? ""),
              SizedBox(height: 20),
              MyDivider(),
              UserInfoItem(title: '아이디', content: user.id ?? ""),
              MyDivider(),
              UserInfoItem(title: '이메일', content: user.email ?? ""),
              MyDivider(),
              UserInfoItem(title: '전화번호', content: user.phoneNumber ?? ""),
              MyDivider(),
              UserInfoItem(title: '피부타입', content: "민감성" ),
              MyDivider(),
              SizedBox(height: 150),
            ])),
        Positioned(
          bottom: 10, // 원하는 위치에 배치
          left: 10, // 원하는 위치에 배치
          right: 10, // 원하는 위치에 배치
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF820E),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(UserInfoModifyRoute());
                    },
                    child: const Text('회원정보 수정'),
                  ),
                ),
                const SizedBox(width: 20), // 간격 조절
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      side: const BorderSide(
                          width: 1.0, color: Color(0xFFFF820E)),
                    ),
                    onPressed: () async {
                      final ok = await popUp(
                        title: '정말 탈퇴하시겠습니까?',
                        context: context,
                      );
                      if (ok) {
                        // 두 번째 버튼의 동작
                      }
                    },
                    child: const Text('회원탈퇴',
                        style: TextStyle(color: Color(0xFFFF820E))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class UserInfoProfile extends StatelessWidget {
  final String nickname;
  const UserInfoProfile({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_outlined, size: 35)),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '이름',
                  style: TextStyle(fontSize: 15, color: Color(0xFF868383)),
                  textAlign: TextAlign.left,
                ),
                Text(
                  nickname,
                  style: TextStyle(fontSize: 15, color: Color(0xFF868383)),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String title;
  final String content;

  const UserInfoItem({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF868383)),
            textAlign: TextAlign.left,
          ),
          Text(
            content,
            style: const TextStyle(fontSize: 17, color: Color(0xFF5C5B5B)),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
