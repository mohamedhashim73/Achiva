import 'package:achiva/controllers/layout_controller/layout_cubit.dart';
import 'package:achiva/controllers/layout_controller/layout_states.dart';
import 'package:achiva/core/Constants/constants.dart';
import 'package:achiva/core/components/textField_widget.dart';
import 'package:achiva/core/constants/extensions.dart';
import 'package:achiva/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/auth_controller/auth_states.dart';
import '../../../core/components/awesome_dialog_widget.dart';
import '../../../core/components/btn_widgets.dart';
import '../../../core/components/drop_down_button.dart';
import '../../../core/components/showSnackBar.dart';

class EditProfileScreen extends StatefulWidget {
  final LayoutCubit layoutCubit;
  const EditProfileScreen({super.key, required this.layoutCubit});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void setUserDataToTextFields(){
    widget.layoutCubit.userImage = null;
    _fnameController.text = widget.layoutCubit.user!.fname;
    _lnameController.text = widget.layoutCubit.user!.lname;
    _emailController.text = widget.layoutCubit.user!.email;
    widget.layoutCubit.chosenGender = widget.layoutCubit.user!.gender;
  }

  @override
  void initState() {
    setUserDataToTextFields();
    super.initState();
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    widget.layoutCubit.chosenGender = null;
    widget.layoutCubit.userImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: ListView(
        padding: AppConstants.kScaffoldPadding.copyWith(bottom: 24),
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                BlocBuilder<LayoutCubit,LayoutStates>(
                  buildWhen: (past,currentState) => currentState is PickedUserImageSuccessfullyState,
                  builder: (context,state){
                    if( widget.layoutCubit.userImage != null )
                      {
                        return CircleAvatar(radius: 64, backgroundImage: FileImage(widget.layoutCubit.userImage!));
                      }
                    else if( widget.layoutCubit.user!.photo != null )
                    {
                      return CircleAvatar(radius: 64, backgroundImage: NetworkImage(widget.layoutCubit.user!.photo!));
                    }
                    else
                    {
                      return CircleAvatar(radius: 64, backgroundColor: Colors.grey[200], child: const Icon(Icons.person, size: 60, color: Colors.grey));
                    }
                  },
                ),
                CircleAvatar(
                  backgroundColor: AppColors.kLightGrey,
                  child: InkWell(
                    onTap: (){
                      showImageSourceDialog(context: context,pickCameraImage: ()=> widget.layoutCubit.pickUserImage(imageSource: ImageSource.camera),pickGalleryImage: ()=> widget.layoutCubit.pickUserImage(imageSource: ImageSource.gallery));
                    },
                    child: Icon(Icons.edit,color: AppColors.kWhiteColor)
                    // child: SvgPicture.asset("assets/images/user-edit.svg",height: 24,width: 24,color: MyColors.kMain,),
                  ),
                ),
              ],
            ),
          ),
          24.vrSpace,
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _fnameController, hint: "First Name", prefixIconData: Icons.account_circle),
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _lnameController, hint: "Last Name", prefixIconData: Icons.account_circle),
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _emailController, hint: "Email", prefixIconData: Icons.email),
          BlocBuilder<LayoutCubit,LayoutStates>(
            buildWhen: (past,current) => current is ChangeGenderStatusState,
            builder: (context,state){
              return DropDownBtnWidget(items: const ["Male","Female"],hint: "Choose your gender", value: widget.layoutCubit.chosenGender,onChanged: (value) => widget.layoutCubit.changeGenderStatus(value : value));
            },
          ),
          8.vrSpace,
          BlocConsumer<LayoutCubit,LayoutStates>(
            listenWhen: (past,current) => current is UpdateUserDataWithFailureState || current is UpdateUserDataSuccessfullyState || current is UpdateUserDataLoadingState,
            listener: (context,state)
            {
              if( state is UpdateUserDataWithFailureState )
              {
                showSnackBarWidget(message: state.message, successOrNot: false, context: context);
              }
              if( state is UpdateUserDataSuccessfullyState )
              {
                showSnackBarWidget(message: "User data updated successfully", successOrNot: true, context: context);
                Navigator.pop(context);
              }
            },
            builder: (context,state) => BtnWidget(
              minWidth: double.infinity,
              onTap: ()
              {
                if( _fnameController.text.isEmpty && _lnameController.text.isEmpty && _emailController.text.isEmpty && widget.layoutCubit.chosenGender == null )
                {
                  showSnackBarWidget(message: "Please, fill data, try again !", successOrNot: false, context: context);
                }
                else if( _fnameController.text.isEmpty && _lnameController.text.isNotEmpty && _emailController.text.isNotEmpty && widget.layoutCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your First Name", successOrNot: false, context: context);
                }
                else if( _fnameController.text.isNotEmpty && _lnameController.text.isEmpty && _emailController.text.isNotEmpty && widget.layoutCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your Last Name", successOrNot: false, context: context);
                }
                else if( _fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty && _emailController.text.isEmpty && widget.layoutCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your Phone Number", successOrNot: false, context: context);
                }
                else if( _fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty && _emailController.text.isNotEmpty && widget.layoutCubit.chosenGender == null )
                {
                  showSnackBarWidget(message: "Please, Choose your gender", successOrNot: false, context: context);
                }
                else
                {
                  widget.layoutCubit.updateUserData(fname: _fnameController.text.trim(), lname: _lnameController.text.trim(),gender: widget.layoutCubit.chosenGender!, userID: AppConstants.kUserID ?? widget.layoutCubit.user!.id, email: _emailController.text.trim());
                }
              },
              title: state is UpdateUserDataLoadingState ? "Update data loading" : "Update",
            ),
          ),
        ],
      ),
    );
  }
}
