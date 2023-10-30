import 'package:beautyminder/bloc/cosmetic/cosmetic_bloc.dart';
import 'package:beautyminder/bloc/cosmetic/cosmetic_event.dart';
import 'package:beautyminder/pages/my/widgets/arrow_icon.dart';
import 'package:beautyminder/pages/my/widgets/cosmetic_list_header.dart';
import 'package:beautyminder/pages/my/widgets/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/cosmetic/cosmetic_state.dart';
import '../../dto/cosmetic_model.dart';
import '../../utils/Utils.dart';
import '../../widget/commonAppBar.dart';
import '../../widget/commonBottomNavigationBar.dart';

enum CosmeticListType { all, expiration, expired }

//즐겨찾기 화장품 리스트
class FavoriteCosmeticListRoute extends MaterialPageRoute {

  FavoriteCosmeticListRoute() : super(
    builder: (context) => BlocProvider<CosmeticBloc>(
      create: (context) => CosmeticBloc()..add(FetchCosmetics()),
      child: FavoriteCosmeticListPage(),
    ),
  );
}

class FavoriteCosmeticListPage extends StatelessWidget {

  const FavoriteCosmeticListPage({super.key});

  @override
  Widget build(BuildContext context) {
    const int currentIndex = 4;

    return Scaffold(
      appBar: CommonAppBar(),
      body: BlocConsumer<CosmeticBloc, CosmeticState> (
        listener: (context, state) {
          if (state is CosmeticError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
        builder: (context, state) {
          if (state is CosmeticInitial) {
            return const Center(
                child: CircularProgressIndicator(strokeWidth: 2));
          } else if (state is CosmeticLoaded) {
            return FavoriteCosmeticListPageBody(cosmetics: state.cosmetics);
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

class FavoriteCosmeticListPageBody extends StatefulWidget {
  final List<Cosmetic> cosmetics;

  //Type에 따라 API 호출
  const FavoriteCosmeticListPageBody({super.key, required this.cosmetics});

  @override
  _FavoriteCosmeticListPageBodyState createState() => _FavoriteCosmeticListPageBodyState();
}

class _FavoriteCosmeticListPageBodyState extends State<FavoriteCosmeticListPageBody> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CosmeticListHeader(itemNum: '총 ${widget.cosmetics.length}개'),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cosmetics.length,
                  itemBuilder: (context, index) {
                    return CosmeticItem(
                      title: widget.cosmetics[index].name,
                      expirationDate: "${widget.cosmetics[index].expirationDate?.year}년 ${widget.cosmetics[index].expirationDate?.month}월 ${widget.cosmetics[index].expirationDate?.day}일",
                      dDay: "D-${widget.cosmetics[index].expirationDate!.difference(DateTime.now()).inDays.toString()}",
                    );
                  },
                  padding: const EdgeInsets.only(bottom: 20),
                ),
              ),
            ],
          )),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            heroTag: 'addCosmetic',
            onPressed: () {
              Navigator.of(context).pushNamed('/addCosmetic');
            },
            child: const Icon(Icons.add),
          ),
        ),
      ]
    );
  }
}

class CosmeticItem extends StatelessWidget {
  final String title;
  final String expirationDate;
  final String dDay;

  const CosmeticItem({super.key, required this.title, required this.expirationDate, required this.dDay});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 88,
                height: 78,
                child: Image.asset('assets/images/profile.png'),
              ),
              const SizedBox(width: 20),
              CosmeticInfo(title: title, dDay: dDay, expirationDate: expirationDate),
            ],
          ),
        ),
        const MyDivider(),
      ],
    );
  }
}

class CosmeticInfo extends StatelessWidget {
  const CosmeticInfo({
    super.key,
    required this.title,
    required this.dDay,
    required this.expirationDate,
  });

  final String title;
  final String dDay;
  final String expirationDate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF3F3535),
                  fontSize: 20,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  dDay,
                  style: const TextStyle(
                    color: Color(0xFF403535),
                    fontSize: 20,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                expirationDate,
                style: const TextStyle(
                  color: Color(0xFFA6A3A3),
                  fontSize: 15,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              IconButton(onPressed: () => {}, icon: arrowIcon(Colors.black))
            ],
          ),
        ],
      ),
    );
  }
}
