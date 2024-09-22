import '../../core/errors/app_failures.dart';

abstract class LayoutStates {}

class InitialLayoutState extends LayoutStates {}

class SignOutSuccessfullyState extends LayoutStates {}

class ToggleGenderState extends LayoutStates {}
class ToggleBetweenFriendsAndGoalsBarState extends LayoutStates {}

class PickedUserImageSuccessfullyState extends LayoutStates {}
class PickedUserImageWithFailureState extends LayoutStates {}

class GetUserDataSuccessfullyState extends LayoutStates {}
class GetUserDataLoadingState extends LayoutStates {}
class GetUserDataWithFailureState extends LayoutStates {
  final Failure failure;
  GetUserDataWithFailureState({required this.failure});
}

class GetUserGoalsSuccessfullyState extends LayoutStates {}
class GetUserGoalsLoadingState extends LayoutStates {}
class GetUserGoalsWithFailureState extends LayoutStates {
  final Failure failure;
  GetUserGoalsWithFailureState({required this.failure});
}

class UpdateUserDataSuccessfullyState extends LayoutStates {}
class UpdateUserDataLoadingState extends LayoutStates {}
class UpdateUserDataWithFailureState extends LayoutStates {
  final String message;
  UpdateUserDataWithFailureState({required this.message});
}

class ChangeUserEmailSuccessfullyState extends LayoutStates {}
class ChangeUserEmailLoadingState extends LayoutStates {}
class ChangeUserEmailWithFailureState extends LayoutStates {
  final String message;
  ChangeUserEmailWithFailureState({required this.message});
}

class ChangePasswordSuccessfullyState extends LayoutStates {}
class ChangePasswordLoadingState extends LayoutStates {}
class ChangePasswordWithFailureState extends LayoutStates {
  final String message;
  ChangePasswordWithFailureState({required this.message});
}

class DeleteAccountSuccessfullyState extends LayoutStates {}
class DeleteAccountLoadingState extends LayoutStates {}
class DeleteAccountWithFailureState extends LayoutStates {
  final String message;
  DeleteAccountWithFailureState({required this.message});
}