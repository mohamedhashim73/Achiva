import 'dart:io';
import 'package:achiva/controllers/layout_controller/layout_cubit.dart';
import 'package:achiva/core/constants/extensions.dart';
import 'package:achiva/core/constants/strings.dart';
import 'package:achiva/views/screens/auth/enter_phone_num_screen.dart';
import 'package:achiva/views/screens/layout/change_user_phone_number_screen.dart';
import 'package:achiva/views/screens/layout/delete_account_screen.dart';
import 'package:achiva/views/screens/layout/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller/auth_cubit.dart';
import '../../views/screens/auth/login_screen.dart';
import '../../views/screens/auth/pick_user_image_screen.dart';
import '../../views/screens/layout/profile_screen.dart';

class AppConstants{
  static String? kUserID;
  static Map<String, Widget Function(BuildContext)> kRoutes = {
    AppStrings.kLoginScreenName: (context) => const LoginScreen(),
    AppStrings.kProfileScreenName: (context) => const ProfileScreen(),
    AppStrings.kPickUserImageScreenName: (context) => const PickUserImageScreen(),
    AppStrings.kEnterPhoneAuthScreenName: (context) => const EnterPhoneAuthScreen(),
    AppStrings.kNotificationsScreenName: (context) => const NotificationsScreen(),
    AppStrings.kChangeUserEmailScreenName: (context) => const ChangeUserPhoneScreen(),
    AppStrings.kDeleteAccountScreenName: (context) => const DeleteAccountScreen(),
  };

  static void kShowImageSourceDialog({required BuildContext context,required Function() pickCameraImage,required Function() pickGalleryImage}) async {

  }

  static Future<File?> kPickedImage({required ImageSource imageSource}) async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: imageSource);
    return pickedImage != null ? File(pickedImage.path) : null;
  }

  static dynamic kProviders = [
    BlocProvider(create: (context) => AuthCubit()),
    BlocProvider(create: (context) => LayoutCubit()),
  ];
  static Widget Function(BuildContext, int) kSeparatorBuilder() => (context,index) => 12.vrSpace;
  static BorderRadius kMainRadius = BorderRadius.circular(12);
  static BorderRadius kMaxRadius = BorderRadius.circular(24);
  static EdgeInsets kContainerPadding = const EdgeInsets.all(16);
  static EdgeInsets kScaffoldPadding = const EdgeInsets.symmetric(horizontal: 16);
  static EdgeInsets kListViewPadding = const EdgeInsets.only(bottom: 24);
  static BoxBorder kMainBorder = Border.all(color: const Color(0xffF1F5F7));
}