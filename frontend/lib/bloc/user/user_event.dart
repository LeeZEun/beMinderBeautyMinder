
abstract class UserEvent {}

class FetchUsers extends UserEvent {}

class FetchReviews extends UserEvent {}

class UpdateUser extends UserEvent {
  final String nickName;
  final String password;
  UpdateUser(this.nickName, this.password);
}
