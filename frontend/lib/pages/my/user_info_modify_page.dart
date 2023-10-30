import 'package:beautyminder/pages/my/user_info_page.dart';
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

class UserInfoModifyRoute extends MaterialPageRoute {
  UserInfoModifyRoute() : super(
    builder: (context) => BlocProvider<UserBloc>(
      create: (context) => UserBloc()..add(FetchUsers()),
      child: const UserInfoModifyPage(),
    ),
  );
}


class UserInfoModifyPage extends StatelessWidget {
  const UserInfoModifyPage({super.key});

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
            return UserInfoModifyPageBody(user: state.user);
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

class UserInfoModifyPageBody extends StatelessWidget {
  final User user;
  const UserInfoModifyPageBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(children: [
                MyPageHeader('회원정보 수정'),
                SizedBox(height: 20),
                UserInfoProfile(nickname: user.nickname ?? ""),
                SizedBox(height: 20),
                MyDivider(),
                UserInfoItem(title: '아이디', content: user.id),
                MyDivider(),
                UserInfoItem(title: '이메일', content: user.email),
                MyDivider(),
                UserInfoItem(title: '전화번호', content: user.phoneNumber ?? ""),
                MyDivider(),
                UserInfoItem(title: '피부타입', content: "민감성" ),
                MyDivider(),
                UserInfoEditItem(title: '닉네임'),
                MyDivider(),
                UserInfoEditItem(title: '현재 비밀번호'),
                UserInfoEditItem(title: '변경할 비밀번호'),
                UserInfoEditItem(title: '비밀번호 재확인'),
                SizedBox(height: 150),
              ]),
            )),
        Positioned(
          bottom: 10, // 원하는 위치에 배치
          left: 10, // 원하는 위치에 배치
          right: 10, // 원하는 위치에 배치
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      side: const BorderSide(
                          width: 1.0, color: Color(0xFFFF820E)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('취소',
                        style: TextStyle(color: Color(0xFFFF820E))),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF820E),
                    ),
                    onPressed: () async {
                      final ok = await popUp(
                        title: '회원 정보를 수정하시겠습니까?',
                        context: context,
                      );
                      if (ok) {
                        // 두 번째 버튼의 동작
                      }
                    },
                    child: const Text('수정'),
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

class UserInfoEditItem extends StatelessWidget {
  final String title;

  const UserInfoEditItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Color(0xFF868383)),
              textAlign: TextAlign.left,
            ),
          ),
          const Flexible(child: TextField()),
        ],
      ),
    );
  }
}