abstract class AuthStates {}

class InitialAuthState extends AuthStates {}

class ChangeBoardingPageViewIndexState extends AuthStates {}
class ChangeGenderStatusState extends AuthStates {}

class UploadUserImageToStorageLoadingState extends AuthStates {}
class UploadUserImageToStorageSuccessfullyState extends AuthStates {}
class UploadUserImageToStorageWithFailureState extends AuthStates {
  final String message;
  UploadUserImageToStorageWithFailureState({required this.message});
}

class UserImagePickedSuccessfullyState extends AuthStates {}
class UserImagePickedWithFailureState extends AuthStates {}

class CreateUserLoadingState extends AuthStates {}
class CreateUserSuccessfullyState extends AuthStates {}
class CreateUserWithFailureState extends AuthStates {
  final String message;
  CreateUserWithFailureState({required this.message});
}

class LoginLoadingState extends AuthStates {}
class LoginSuccessfullyState extends AuthStates {}
class LoginWithFailureState extends AuthStates {
  final String message;
  LoginWithFailureState({required this.message});
}

class SendPasswordResetEmailLoadingState extends AuthStates {}
class SendPasswordResetEmailSuccessfullyState extends AuthStates {}
class SendPasswordResetEmailWithFailureState extends AuthStates {
  final String message;
  SendPasswordResetEmailWithFailureState({required this.message});
}

class SaveUserDataOnFirestoreLoadingState extends AuthStates {}
class SaveUserDataOnFirestoreWithFailureState extends AuthStates {}

