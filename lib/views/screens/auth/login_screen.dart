import 'package:achiva/core/constants/extensions.dart';
import 'package:achiva/views/screens/auth/enter_otp_of_phone_auth_screen.dart';
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
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.clear();
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
            const Text("Hello,\nWelcome back !",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,height: 1.6),),
            24.vrSpace,
            TextFieldWidget(controller: _phoneNumberController,hint: "Phone Number", prefixIconData: Icons.phone,textInputType: TextInputType.number),
            12.vrSpace,
            BlocConsumer<AuthCubit,AuthStates>(
              listenWhen: (past,current) => current is CodeAutoRetrievalTimeOuState || current is LoginSuccessfullyState || current is LoginWithFailureState,
              listener: (context,state)
              {
                if( state is LoginWithFailureState )
                {
                  showSnackBarWidget(message: state.message, successOrNot: false, context: context);
                }
                if( state is LoginSuccessfullyState )
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EnterOtpOfPhoneAuthScreen(phoneNumber: _phoneNumberController.text.trim(),openAfterUserLogin: true)));
                }
              },
              builder: (context,state) => BtnWidget(
                minWidth: double.infinity,
                onTap: ()
                {
                  if( _phoneNumberController.text.isEmpty )
                  {
                    showSnackBarWidget(message: "Please, Enter Phone number, try again !", successOrNot: false, context: context);
                  }
                  else
                  {
                    authCubit.login(phoneNumber: _phoneNumberController.text.trim());
                  }
                },
                title: state is LoginLoadingState ? "Sign in loading" : "Sign in",
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
                    Navigator.pushNamed(context, AppStrings.kEnterPhoneAuthScreenName);
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

