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
import '../../core/network/check_internet_connection.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(InitialAuthState());
  static AuthCubit getInstance(BuildContext context) => BlocProvider.of<AuthCubit>(context);

  int currentBoardingPageViewIndex = 0;
  void changeBoardingPageViewIndex(int index){
    currentBoardingPageViewIndex = index;
    emit(ChangeBoardingPageViewIndexState());
  }

  String? chosenGender;
  void changeGenderStatus({required String value}){
    chosenGender = value;
    emit(ChangeGenderStatusState());
  }

  String? userID;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void createUser({required String fname,required String lname,required String email,required String gender,required String phoneNumber,required String password}) async {
    try{
      emit(CreateUserLoadingState());
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if( userCredential.user != null )
      {
        await saveUserData(password: password,fname: fname, lname: lname, email: email, gender: gender, userID: userCredential.user!.uid, phoneNumber: phoneNumber);
      }
    }
    on FirebaseException catch(e) {
      emit(CreateUserWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
    }
  }

  void login({required String email,required String password}) async {
    try{
      emit(LoginLoadingState());
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if( userCredential.user != null )
      {
        AppConstants.kUserID = userCredential.user!.uid;
        await CacheHelper.insertString(key: AppStrings.kUserIDName, value: userCredential.user!.uid);
        emit(LoginSuccessfullyState());
      }
    } on FirebaseAuthException catch (e) {
      if( e.code == 'invalid-credential' )
        {
          emit(LoginWithFailureState(message: "Incorrect Data entered, check it and try again"));
        }
      else if ( e.code == 'too-many-requests' )
        {
          emit(LoginWithFailureState(message: "Access to this account has been temporarily disabled due to many failed login"));
        }
      else
      {
        emit(LoginWithFailureState(message: await CheckInternetConnection.getStatus() ? "Check Internet connection, try again !" : "Something went wrong, try again later"));
      }
    }
  }

  Future<void> saveUserData({required String password,required String fname,required String lname,required String email,required String gender,required String userID,required String phoneNumber}) async {
    emit(SaveUserDataOnFirestoreLoadingState());
    await CacheHelper.insertString(key: AppStrings.kUserIDName, value: userID);
    AppConstants.kUserID = userID;
    UserModel model = UserModel(id: userID,fname: fname, lname: lname, email: email, gender: gender, photo: null, phoneNumber: phoneNumber, streak: 0, productivity: 0);
    await FirebaseFirestore.instance.collection(AppStrings.kUsersCollectionName).doc(userID).set(model.toJson());
    emit(CreateUserSuccessfullyState());
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

  void forgetPassword({required String email}) async {
    try{
      emit(SendPasswordResetEmailLoadingState());
      await firebaseAuth.sendPasswordResetEmail(email: email);
      emit(SendPasswordResetEmailSuccessfullyState());
    }
    on FirebaseException catch(e){
      emit(SendPasswordResetEmailWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
    }
  }
}