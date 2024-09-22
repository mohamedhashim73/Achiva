abstract class AuthStates {}

class InitialAuthState extends AuthStates {}
class PhoneNumberVerifiedLoadingState extends AuthStates {}
class CodeAutoRetrievalTimeOuState extends AuthStates {}
class PhoneNumberVerifiedSuccessfullyState extends AuthStates {}
class PhoneNumberVerifiedWithFailureState extends AuthStates {
  String message;
  PhoneNumberVerifiedWithFailureState({required this.message});
}
class ConfirmAuthOtpLoadingState extends AuthStates {}
class ConfirmAuthOtpSuccessfullyState extends AuthStates {}
class ConfirmAuthOtpWithFailureState extends AuthStates {
  String message;
  ConfirmAuthOtpWithFailureState({required this.message});
}
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

class SaveUserDataOnFirestoreLoadingState extends AuthStates {}
class SaveUserDataOnFirestoreSuccessfullyState extends AuthStates {}
class SaveUserDataOnFirestoreWithFailureState extends AuthStates {
  final String message;
  SaveUserDataOnFirestoreWithFailureState({required this.message});
}

class LoginLoadingState extends AuthStates {}
class LoginSuccessfullyState extends AuthStates {}
class LoginWithFailureState extends AuthStates {
  final String message;
  LoginWithFailureState({required this.message});
}


