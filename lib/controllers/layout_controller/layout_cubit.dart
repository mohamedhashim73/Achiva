import 'dart:io';
import 'package:achiva/core/constants/constants.dart';
import 'package:achiva/core/constants/strings.dart';
import 'package:achiva/core/errors/app_failures.dart';
import 'package:achiva/core/network/check_internet_connection.dart';
import 'package:achiva/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/network/cache_network.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates>{
  LayoutCubit() : super(InitialLayoutState());
  static LayoutCubit getInstance(BuildContext context) => BlocProvider.of<LayoutCubit>(context);
  
  final FirebaseFirestore cloudFirestore = FirebaseFirestore.instance;
  UserModel? user;
  Future<void> getUserData({bool? updateUserData}) async {
    try{
      if( user == null || updateUserData != null )
      {
        emit(GetUserDataLoadingState());
        await cloudFirestore.collection(AppStrings.kUsersCollectionName).doc(CacheHelper.getString(key: AppStrings.kUserIDName) ?? AppConstants.kUserID!).get().then((e){
          if( e.data() != null )
          {
            user = UserModel.fromJson(json: e.data()!);
          }
        });
        emit(GetUserDataSuccessfullyState());
      }
    }
    on FirebaseException catch(e){
      emit(GetUserDataWithFailureState(failure: await CheckInternetConnection.getStatus() ? InternetNotFoundFailure() : ServerFailure()));
    }
  }

  File? userImage;
  Future<void> pickUserImage({required ImageSource imageSource}) async {
    userImage = await AppConstants.kPickedImage(imageSource: imageSource);
    userImage != null ? emit(PickedUserImageSuccessfullyState()) : emit(PickedUserImageWithFailureState());
  }

  String? chosenGender;
  void changeGenderStatus({required String value}){
    chosenGender = value;
    emit(ToggleGenderState());
  }

  Future<String?> uploadImageToStorage() async {
    try{
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref().child("${AppStrings.kUsersCollectionName}/${Uri.file(userImage!.path).pathSegments.last}").putFile(userImage!);
      return await taskSnapshot.ref.getDownloadURL();
    }
    on FirebaseException catch(e){
      debugPrint("Error while upload user image to storage, ${"Error, ${e.code.replaceAll("-", " ")}"}");
      return null;
    }
  }

  Future<void> updateUserData({required String fname,required String lname,required String gender,required String userID,required String phoneNumber}) async {
    try{
      emit(UpdateUserDataLoadingState());
      String? urlOfUpdatedUserImage;
      if( userImage != null )
      {
        urlOfUpdatedUserImage = await uploadImageToStorage();
      }
      UserModel model = UserModel(id: userID,fname: fname, lname: lname, email: user!.email, gender: gender, photo: urlOfUpdatedUserImage ?? user!.photo, phoneNumber: phoneNumber, streak: user!.streak, productivity: user!.productivity);
      await FirebaseFirestore.instance.collection(AppStrings.kUsersCollectionName).doc(userID).set(model.toJson());
      await getUserData(updateUserData: true);
      emit(UpdateUserDataSuccessfullyState());
    }
    on FirebaseException catch(e){
      emit(UpdateUserDataWithFailureState(message: await CheckInternetConnection.getStatus() ? AppStrings.kInternetLostMessage : AppStrings.kServerFailureMessage));
    }
  }

  // TODO: ChangeUserEmail must verify it first
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> changeUserEmail({required String password,required String email}) async {
    try{
      emit(ChangeUserEmailLoadingState());
      User? currentUser = firebaseAuth.currentUser;
      if( currentUser != null )
        {
          AuthCredential currentCredential = EmailAuthProvider.credential(email: currentUser.email!, password: password);
          await currentUser.reauthenticateWithCredential(currentCredential);
          await currentUser.verifyBeforeUpdateEmail(email);
          // await signOut(notToEmitToState: true);
          emit(ChangeUserEmailSuccessfullyState());
        }
    }
    on FirebaseException catch(e){
      debugPrint("Code : ${e.code}");
      // TODO: unknown in case password is correct but inValid Email entered
      emit(ChangeUserEmailWithFailureState(message: "Error, ${e.code == "unknown" ? "Invalid Email entered, try a real one!" : e.code.replaceAll("-", " ")}"));
    }
  }

  // TODO: when listen on user data, if there is change on email ( Firestore , CurrentUser ) after user changed email and verified it
  void updateUserEmailOnDatabase({required String email}) async {
    try{
      await FirebaseFirestore.instance.collection(AppStrings.kUsersCollectionName).doc(CacheHelper.getString(key: AppStrings.kUserIDName) ?? AppConstants.kUserID!).update({
        "email" : email
      });
      user!.email = email;
      emit(GetUserDataSuccessfullyState());
    }
    on FirebaseException catch(e){
      debugPrint("Error while updating userEmail on Firestore, ${e.code}");
    }
  }

  Future<void> changeUserPassword({required String email,required String currentPassword,required String newPassword}) async {
    try{
      emit(ChangePasswordLoadingState());
      User? currentUser = firebaseAuth.currentUser;
      if( currentUser != null )
        {
          AuthCredential currentCredential = EmailAuthProvider.credential(email: email, password: currentPassword);
          await currentUser.reauthenticateWithCredential(currentCredential);
          await currentUser.updatePassword(newPassword);
          emit(ChangePasswordSuccessfullyState());
        }
    }
    on FirebaseException catch(e){
      emit(ChangePasswordWithFailureState(message: "Error, ${e.code.replaceAll("-", " ")}"));
    }
  }

  Future<void> deleteAccount({required String email,required String password}) async {
    try{
      emit(DeleteAccountLoadingState());
      User? currentUser = firebaseAuth.currentUser;
      if( currentUser != null )
      {
        String userID = currentUser.uid;
        AuthCredential currentCredential = EmailAuthProvider.credential(email: email, password: password);
        await currentUser.reauthenticateWithCredential(currentCredential);
        await currentUser.delete();
        await cloudFirestore.collection(AppStrings.kUsersCollectionName).doc(userID).delete();
        await signOut(notToEmitToState: true);
        emit(DeleteAccountSuccessfullyState());
      }
    }
    on FirebaseException catch(e){
      debugPrint("Code : ${e.code}");
      emit(DeleteAccountWithFailureState(message: "Error, ${e.code == "invalid-credential" ? "Incorrect password entered" : e.code.replaceAll("-", " ")}"));
    }
  }

  Future<void> signOut({required bool notToEmitToState}) async {
    await CacheHelper.clearCache();
    AppConstants.kUserID = null;
    user = null;
    if( notToEmitToState == false )
      {
        emit(SignOutSuccessfullyState());
      }
  }

}