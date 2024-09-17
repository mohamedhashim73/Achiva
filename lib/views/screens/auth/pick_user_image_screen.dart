import 'dart:io';
import 'package:achiva/controllers/auth_controller/auth_cubit.dart';
import 'package:achiva/controllers/auth_controller/auth_states.dart';
import 'package:achiva/core/Constants/constants.dart';
import 'package:achiva/core/components/btn_widgets.dart';
import 'package:achiva/core/constants/extensions.dart';
import 'package:achiva/core/constants/strings.dart';
import 'package:achiva/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/components/awesome_dialog_widget.dart';
import '../../../core/components/showSnackBar.dart';

class PickUserImageScreen extends StatelessWidget {
  const PickUserImageScreen ({super.key});
  @override
  Widget build(BuildContext context) {
    final AuthCubit cubit = AuthCubit.getInstance(context);
    return Scaffold(
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<AuthCubit,AuthStates>(
                buildWhen: (past,current) => current is UserImagePickedSuccessfullyState,
                builder: (context,state){
                  if( cubit.userImage == null )
                    {
                      return CircleAvatar(radius: 80, backgroundColor: Colors.grey[200], child: const Icon(Icons.person, size: 60, color: Colors.grey),);
                    }
                  else
                    {
                      return CircleAvatar(radius: 80, backgroundImage: FileImage(File(cubit.userImage!.path)),);
                    }
                },
              ),
              24.vrSpace,
              ElevatedButton(
                onPressed: () => showImageSourceDialog(context: context,pickCameraImage: ()=> cubit.pickUserImage(imageSource: ImageSource.camera),pickGalleryImage: ()=> cubit.pickUserImage(imageSource: ImageSource.gallery)),
                child: Container(
                  padding: AppConstants.kContainerPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.image),
                      12.hrSpace,
                      const Text('Add Profile Picture',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocConsumer<AuthCubit,AuthStates>(
                buildWhen: (past,currentState) => currentState is UploadUserImageToStorageSuccessfullyState || currentState is UploadUserImageToStorageWithFailureState || currentState is UploadUserImageToStorageLoadingState,
                listenWhen: (past,currentState) => currentState is UploadUserImageToStorageSuccessfullyState || currentState is UploadUserImageToStorageWithFailureState || currentState is UploadUserImageToStorageLoadingState,
                listener: (context,state){
                  if( state is UploadUserImageToStorageWithFailureState )
                  {
                    showSnackBarWidget(message: state.message, successOrNot: false, context: context);
                  }
                  if( state is UploadUserImageToStorageSuccessfullyState )
                  {
                    showSnackBarWidget(message: "Image uploaded successfully", successOrNot: true, context: context);
                    Navigator.pushNamedAndRemoveUntil(context, AppStrings.kProfileScreenName, (_)=> true);
                  }
                },
                  builder: (context,state) {
                  return BtnWidget(
                    minWidth: null,
                    onTap: ()
                    {
                      if( cubit.userImage != null )
                        {
                          cubit.uploadUserImageToStorage(userID: AppConstants.kUserID!);
                        }
                      else
                        {
                          Navigator.pushNamedAndRemoveUntil(context, AppStrings.kProfileScreenName, (_)=> true);
                        }
                    },
                    title: state is UploadUserImageToStorageLoadingState ? "Upload image loading" : 'Continue',
                  );
                }
              ),
              16.vrSpace,
              BtnWidget(
                onTap: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, AppStrings.kProfileScreenName, (_)=> true);
                },
                backgroundColor: Colors.transparent,
                borderColor: AppColors.kMain,
                txtColor: AppColors.kBlack,
                title: 'Skip',
              ),
            ],
          ),
        ),
      ),
    );
  }

}
