import 'dart:io';
import 'package:achiva/core/Constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:achiva/core/constants/strings.dart';
import 'package:achiva/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/network/cache_network.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(InitialAuthState());
  static AuthCubit getInstance(BuildContext context) => BlocProvider.of<AuthCubit>(context);

  int currentBoardingPageViewIndex = 0;
  void changeBoardingPageViewIndex(int index){
    currentBoardingPageViewIndex = index;
    emit(ChangeBoardingPageViewIndexState());
  }

  String? verificationID;
  void verifyPhoneNumber({required String phoneNumber}) async {
    try{
      emit(PhoneNumberVerifiedLoadingState());
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e)
        {
          emit(PhoneNumberVerifiedWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
        },
        codeSent: (String verificationId, int? resendToken)
        {
          verificationID = verificationId;
          emit(PhoneNumberVerifiedSuccessfullyState());
        },
        codeAutoRetrievalTimeout: (String verificationId)
        {
          verificationID = verificationId;
          emit(CodeAutoRetrievalTimeOuState());
        },
      );
    }
    on FirebaseException catch(e){
      emit(PhoneNumberVerifiedWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
    }
  }

  Future<void> signInWithPhone({required PhoneAuthCredential credential,required bool useWithLoginNotRegister}) async {
    await FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) async {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(AppStrings.kUsersCollectionName).doc(userCredential.user!.uid).get();
      if( documentSnapshot.exists == false && useWithLoginNotRegister == true )
        {
          emit(ConfirmAuthOtpWithFailureState(message: "Not found a User with this Phone Number.\nCreate a new account with it !"));
        }
      else
        {
          AppConstants.kUserID = userCredential.user!.uid;
          await CacheHelper.insertString(key: AppStrings.kUserIDName, value: userCredential.user!.uid);
          emit(ConfirmAuthOtpSuccessfullyState());
        }
    });
  }

  void confirmPinCode({required String code,required bool useWithLoginNotRegister}) async {
    try{
      emit(ConfirmAuthOtpLoadingState());
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID!, smsCode: code);
      await signInWithPhone(credential: credential,useWithLoginNotRegister: useWithLoginNotRegister);
    }
    on FirebaseException catch(e){
      emit(ConfirmAuthOtpWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
    }
  }

  String? chosenGender;
  void changeGenderStatus({required String value}){
    chosenGender = value;
    emit(ChangeGenderStatusState());
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void saveUserDataOnDataBase({required String userID,required String fname,required String lname,required String email,required String gender,required String phoneNumber}) async {
    try{
      emit(SaveUserDataOnFirestoreLoadingState());
      UserModel model = UserModel(id: userID,fname: fname, lname: lname, email: email, gender: gender, photo: null, phoneNumber: phoneNumber, streak: 0, productivity: 0);
      await FirebaseFirestore.instance.collection(AppStrings.kUsersCollectionName).doc(userID).set(model.toJson());
      emit(SaveUserDataOnFirestoreSuccessfullyState());
    }
    on FirebaseException catch(e) {
      emit(SaveUserDataOnFirestoreWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
    }
  }

  void login({required String phoneNumber}) async {
    try{
      emit(LoginLoadingState());
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential){},
        verificationFailed: (FirebaseAuthException e)
        {
          debugPrint("Failure inside code, ${e.code}");
          emit(LoginWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
        },
        codeSent: (String verificationId, int? resendToken)
        {
          verificationID = verificationId;
          emit(LoginSuccessfullyState());
        },
        codeAutoRetrievalTimeout: (String verificationId)
        {
          verificationID = verificationId;
          emit(CodeAutoRetrievalTimeOuState());
        },
      );
    } on FirebaseException catch (e) {
      debugPrint("Error, ${e.code}");
      emit(LoginWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
    }
  }

  File? userImage;
  Future<void> pickUserImage({required ImageSource imageSource}) async {
    userImage = await AppConstants.kPickedImage(imageSource: imageSource);
    userImage != null ? emit(UserImagePickedSuccessfullyState()) : emit(UserImagePickedWithFailureState());
  }

  void uploadUserImageToStorage({required String userID}) async {
    try{
      emit(UploadUserImageToStorageLoadingState());
      await FirebaseStorage.instance.ref()
          .child("${AppStrings.kUsersCollectionName}/${Uri.file(userImage!.path).pathSegments.last}")
          .putFile(userImage!)
          .then((val) async {
            val.ref.getDownloadURL().then((urlOfImageUploaded) async {
              debugPrint(urlOfImageUploaded);
              await FirebaseFirestore.instance.collection(AppStrings.kUsersCollectionName).doc(userID).update(
                  {
                    "photo" : urlOfImageUploaded
                  }
              );
          emit(UploadUserImageToStorageSuccessfullyState());
        });
      });
    }
    on FirebaseException catch(e){
      emit(UploadUserImageToStorageWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
    }
  }
}