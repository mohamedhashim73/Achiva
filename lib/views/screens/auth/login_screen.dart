import 'package:achiva/core/constants/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/auth_controller/auth_cubit.dart';
import '../../../controllers/auth_controller/auth_states.dart';
import '../../../core/Constants/constants.dart';
import '../../../core/components/btn_widgets.dart';
import '../../../core/components/showSnackBar.dart';
import '../../../core/components/textField_widget.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.getInstance(context);
    return Scaffold(
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: ListView(
          padding: EdgeInsets.zero.copyWith(top: MediaQuery.of(context).padding.top + 34,bottom: 24),
          children:
          [
            const Text("Hello,\nWelcome Back!",style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,height: 1.6),),
            20.vrSpace,
            TextFieldWidget(controller: _emailController,hint: "Email", prefixIconData: Icons.email,textInputAction: TextInputAction.next),
            TextFieldWidget(controller: _passwordController, hint: "Password",secureTxt: true,prefixIconData: Icons.password),
            8.vrSpace,
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, AppStrings.kForgetPasswordScreenName);
                },
                child: Text("Forgot Password ?",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: AppColors.kRed),),
              ),
            ),
            20.vrSpace,
            BlocConsumer<AuthCubit,AuthStates>(
              listenWhen: (past,current) => current is LoginSuccessfullyState || current is LoginWithFailureState,
              listener: (context,state)
              {
                if( state is LoginWithFailureState )
                {
                  showSnackBarWidget(message: state.message, successOrNot: false, context: context);
                }
                if( state is LoginSuccessfullyState )
                {
                  showSnackBarWidget(message: "Login successfully", successOrNot: true, context: context);
                  Navigator.pushReplacementNamed(context, AppStrings.kProfileScreenName);
                }
              },
              builder: (context,state) => BtnWidget(
                minWidth: double.infinity,
                onTap: ()
                {
                  if( _emailController.text.isEmpty && _passwordController.text.isEmpty )
                  {
                    showSnackBarWidget(message: "Please, fill data, try again !", successOrNot: false, context: context);
                  }
                  else if ( _emailController.text.isEmpty && _passwordController.text.isNotEmpty )
                  {
                    showSnackBarWidget(message: "Please, enter your email", successOrNot: false, context: context);
                  }
                  else if ( _passwordController.text.isEmpty && _emailController.text.isNotEmpty )
                  {
                    showSnackBarWidget(message: "Please, enter your password", successOrNot: false, context: context);
                  }
                  else
                  {
                    authCubit.login(email: _emailController.text.trim(), password: _passwordController.text.trim());
                  }
                },
                title: state is LoginLoadingState ? "Sing in loading" : "Sign in",
              ),
            ),
            16.vrSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Text("Don't have an account ?",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kDarkGrey),),
                6.hrSpace,
                InkWell(
                  onTap: ()
                  {
                    Navigator.pushNamed(context, AppStrings.kRegisterScreenName);
                  },
                  child: Text("Click here",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kMain),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}

