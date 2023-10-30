import 'package:beautyminder/dto/user_model.dart';

import '../../dto/review_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

class UserReviewLoaded extends UserState {
  final List<Review> reviews;
  UserReviewLoaded(this.reviews);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
