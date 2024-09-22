import 'package:achiva/core/Constants/constants.dart';
import 'package:achiva/core/components/textField_widget.dart';
import 'package:achiva/core/constants/extensions.dart';
import 'package:achiva/core/network/cache_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/auth_controller/auth_cubit.dart';
import '../../../controllers/auth_controller/auth_states.dart';
import '../../../core/components/btn_widgets.dart';
import '../../../core/components/drop_down_button.dart';
import '../../../core/components/showSnackBar.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  final String phoneNumber;
  const RegisterScreen({super.key, required this.phoneNumber});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.getInstance(context)..userImage = null..chosenGender = null;
    return Scaffold(
      body: ListView(
        padding: AppConstants.kScaffoldPadding.copyWith(top: MediaQuery.of(context).padding.top + 34,bottom: 24),
        children: [
          const Text("Hello,",style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold)),
          Text("Complete create your account!",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,height: 1.6,color: AppColors.kLightGrey),),
          20.vrSpace,
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _fnameController, hint: "First Name", prefixIconData: Icons.account_circle),
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _lnameController, hint: "Last Name", prefixIconData: Icons.account_circle),
          BlocBuilder<AuthCubit,AuthStates>(
            buildWhen: (past,current) => current is ChangeGenderStatusState,
            builder: (context,state){
              return DropDownBtnWidget(items: const ["Male","Female"],hint: "Choose your gender", value: authCubit.chosenGender,onChanged: (value) => authCubit.changeGenderStatus(value : value));
            },
          ),
          TextFieldWidget(controller: _emailController, hint: "Email", prefixIconData: Icons.email),
          12.vrSpace,
          BlocConsumer<AuthCubit,AuthStates>(
            listenWhen: (past,current) => current is SaveUserDataOnFirestoreWithFailureState || current is SaveUserDataOnFirestoreSuccessfullyState || current is SaveUserDataOnFirestoreLoadingState,
            listener: (context,state)
            {
              if( state is SaveUserDataOnFirestoreWithFailureState )
              {
                showSnackBarWidget(message: state.message, successOrNot: false, context: context);
              }
              if( state is SaveUserDataOnFirestoreSuccessfullyState )
              {
                showSnackBarWidget(message: "User created successfully", successOrNot: true, context: context);
                Navigator.pushNamedAndRemoveUntil(context, AppStrings.kPickUserImageScreenName, (_)=> true);
              }
            },
            builder: (context,state) => BtnWidget(
              minWidth: double.infinity,
              onTap: ()
              {
                if( _emailController.text.isEmpty && _fnameController.text.isEmpty && _lnameController.text.isEmpty && authCubit.chosenGender == null )
                {
                  showSnackBarWidget(message: "Please, fill data, try again !", successOrNot: false, context: context);
                }
                else if( _emailController.text.isEmpty && _fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty && authCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your email", successOrNot: false, context: context);
                }
                else if( _emailController.text.isNotEmpty && _fnameController.text.isEmpty && _lnameController.text.isNotEmpty && authCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your First Name", successOrNot: false, context: context);
                }
                else if( _emailController.text.isNotEmpty && _fnameController.text.isNotEmpty && _lnameController.text.isEmpty && authCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your Last Name", successOrNot: false, context: context);
                }
                else if( _emailController.text.isNotEmpty && _fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty && authCubit.chosenGender == null )
                {
                  showSnackBarWidget(message: "Please, Choose your gender", successOrNot: false, context: context);
                }
                else
                {
                  authCubit.saveUserDataOnDataBase(userID: CacheHelper.getString(key: AppStrings.kUserIDName) ?? AppConstants.kUserID!,fname: _fnameController.text.trim(), lname: _lnameController.text.trim(), email: _emailController.text.trim(), gender: authCubit.chosenGender!, phoneNumber: widget.phoneNumber);
                }
              },
              title: state is SaveUserDataOnFirestoreLoadingState ? "Save User Data loading" : "Continue",
            ),
          ),
          16.vrSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Text("Already have an account ?",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kDarkGrey),),
              6.hrSpace,
              InkWell(
                onTap: ()
                {
                  Navigator.pushNamed(context, AppStrings.kLoginScreenName);
                },
                child: Text("Click here",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kMain),),
              )
            ],
          )
        ],
      ),
    );
  }
}
