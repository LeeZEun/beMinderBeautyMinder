
import 'package:beautyminder/bloc/user/user_event.dart';
import 'package:beautyminder/dto/review_model.dart';
import 'package:beautyminder/pages/my/my_page.dart';
import 'package:beautyminder/pages/my/user_info_page.dart';
import 'package:beautyminder/pages/my/widgets/my_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_state.dart';
import '../../utils/Utils.dart';
import '../../widget/commonAppBar.dart';
import '../../widget/commonBottomNavigationBar.dart';

class MyReviewRoute extends MaterialPageRoute {
  final String nickname;
  final String profileImageUrl;

  MyReviewRoute(this.nickname, this.profileImageUrl) : super(
    builder: (context) => BlocProvider<UserBloc>(
      create: (context) => UserBloc()..add(FetchReviews()),
      child: MyReviewPage(nickname: nickname, profileImageUrl: profileImageUrl),
    ),
  );
}

class MyReviewPage extends StatelessWidget {
  final String nickname;
  final String profileImageUrl;

  const MyReviewPage({super.key, required this.nickname, required this.profileImageUrl});

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
          } else if (state is UserReviewLoaded) {
            return MyReviewPageBody(reviews: state.reviews, nickname: nickname, profileImageUrl: profileImageUrl,);
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

class MyReviewPageBody extends StatelessWidget {
  final List<Review> reviews;
  final String nickname;
  final String profileImageUrl;

  const MyReviewPageBody({super.key, required this.reviews, required this.nickname, required this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: MyPageProfile(nickname: nickname),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('작성한 리뷰(${reviews.length})', ),
            ),
            MyDivider(),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return MyReviewItem(review: reviews[index]);
                },
                padding: const EdgeInsets.only(bottom: 20),
              ),
            ),
          ],
        ));
  }
}

class MyReviewItem extends StatelessWidget {
  final Review review;
  const MyReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(review.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text(review.cosmeticName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: MyDivider(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.review,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)),
                const SizedBox(height: 10),
                Text('작성날짜: ${review.date}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






