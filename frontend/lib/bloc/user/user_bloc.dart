import 'package:beautyminder/bloc/user/user_event.dart';
import 'package:beautyminder/bloc/user/user_state.dart';
import 'package:beautyminder/dto/review_model.dart';
import 'package:beautyminder/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dto/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<UpdateUser>(_onUpdateUser);
    on<FetchReviews>(_onFetchReviews);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    try {
      //final User = await APIService.getUserProfile();

      //fake data
      final user = User(
        id: "asdf",
        email: 'fake 이메일',
        nickname: 'fake 닉네임',
        phoneNumber: '010-1234-5678',
        password: 'password',
        createdAt: DateTime.now(),
        authorities: "ROLE_USER",
      );

      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      final user = await APIService.getUserProfile();
      emit(UserLoaded(user.value!));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onFetchReviews(FetchReviews event, Emitter<UserState> emit) async {
    try {
      //API 호출
      //final reviews = await APIService.getUserProfile();

      //fake data
      List<Review> reviews = List<Review>.generate(10, (index) => Review(
        id: index.toString(),
        cosmeticName: '테스트 화장품 $index',
        imageUrl: 'https://picsum.photos/200/300',
        review: '테스트 리뷰입니다. $index',
        date: DateTime.now().toString(),
      ));

      emit(UserReviewLoaded(reviews));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}