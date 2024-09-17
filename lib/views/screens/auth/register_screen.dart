import 'package:achiva/core/Constants/constants.dart';
import 'package:achiva/core/components/textField_widget.dart';
import 'package:achiva/core/constants/extensions.dart';
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
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.getInstance(context)..userImage = null..chosenGender = null;
    return Scaffold(
      body: ListView(
        padding: AppConstants.kScaffoldPadding.copyWith(top: MediaQuery.of(context).padding.top + 34,bottom: 24),
        children: [
          const Text("Hello,\nCreate your account!",style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,height: 1.6),),
          20.vrSpace,
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _fnameController, hint: "First Name", prefixIconData: Icons.account_circle),
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _lnameController, hint: "Last Name", prefixIconData: Icons.account_circle),
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _phoneNumberController, hint: "Phone Number", prefixIconData: Icons.phone,textInputType: TextInputType.number),
          BlocBuilder<AuthCubit,AuthStates>(
            buildWhen: (past,current) => current is ChangeGenderStatusState,
            builder: (context,state){
              return DropDownBtnWidget(items: const ["Male","Female"],hint: "Choose your gender", value: authCubit.chosenGender,onChanged: (value) => authCubit.changeGenderStatus(value : value));
            },
          ),
          TextFieldWidget(textInputAction: TextInputAction.next,controller: _emailController, hint: "Email", prefixIconData: Icons.email),
          TextFieldWidget(controller: _passwordController, hint: "Password", prefixIconData: Icons.password,secureTxt: true),
          8.vrSpace,
          BlocConsumer<AuthCubit,AuthStates>(
            listenWhen: (past,current) => current is CreateUserWithFailureState || current is CreateUserSuccessfullyState || current is CreateUserLoadingState,
            listener: (context,state)
            {
              if( state is CreateUserWithFailureState )
              {
                showSnackBarWidget(message: state.message, successOrNot: false, context: context);
              }
              if( state is CreateUserSuccessfullyState )
              {
                showSnackBarWidget(message: "User created successfully", successOrNot: true, context: context);
                Navigator.pushNamedAndRemoveUntil(context, AppStrings.kPickUserImageScreenName, (_)=> true);
              }
            },
            builder: (context,state) => BtnWidget(
              minWidth: double.infinity,
              onTap: ()
              {
                if( _passwordController.text.isEmpty && _emailController.text.isEmpty && _fnameController.text.isEmpty && _lnameController.text.isEmpty && _phoneNumberController.text.isEmpty && authCubit.chosenGender == null )
                {
                  showSnackBarWidget(message: "Please, fill data, try again !", successOrNot: false, context: context);
                }
                else if( _passwordController.text.isEmpty && _emailController.text.isNotEmpty && _fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty && _phoneNumberController.text.isNotEmpty && authCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your password", successOrNot: false, context: context);
                }
                else if( _passwordController.text.isNotEmpty && _emailController.text.isEmpty && _fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty && _phoneNumberController.text.isNotEmpty && authCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your email", successOrNot: false, context: context);
                }
                else if( _passwordController.text.isNotEmpty && _emailController.text.isNotEmpty && _fnameController.text.isEmpty && _lnameController.text.isNotEmpty && _phoneNumberController.text.isNotEmpty && authCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your First Name", successOrNot: false, context: context);
                }
                else if( _passwordController.text.isNotEmpty && _emailController.text.isNotEmpty && _fnameController.text.isNotEmpty && _lnameController.text.isEmpty && _phoneNumberController.text.isNotEmpty && authCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your Last Name", successOrNot: false, context: context);
                }
                else if( _passwordController.text.isNotEmpty && _emailController.text.isNotEmpty && _fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty && _phoneNumberController.text.isEmpty && authCubit.chosenGender != null )
                {
                  showSnackBarWidget(message: "Please, enter your Phone Number", successOrNot: false, context: context);
                }
                else if( _passwordController.text.isNotEmpty && _emailController.text.isNotEmpty && _fnameController.text.isNotEmpty && _lnameController.text.isNotEmpty && _phoneNumberController.text.isNotEmpty && authCubit.chosenGender == null )
                {
                  showSnackBarWidget(message: "Please, Choose your gender", successOrNot: false, context: context);
                }
                else
                {
                  authCubit.createUser(fname: _fnameController.text.trim(), lname: _lnameController.text.trim(), email: _emailController.text.trim(), gender: authCubit.chosenGender!, phoneNumber: _phoneNumberController.text.trim(), password: _passwordController.text.trim());
                }
              },
              title: state is CreateUserLoadingState ? "Create user loading" : "Create user",
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
