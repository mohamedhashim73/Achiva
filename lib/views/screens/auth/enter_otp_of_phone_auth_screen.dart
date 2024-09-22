import 'package:achiva/core/constants/extensions.dart';
import 'package:achiva/views/screens/auth/register_screen.dart';
import 'package:achiva/views/screens/layout/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/auth_controller/auth_cubit.dart';
import '../../../controllers/auth_controller/auth_states.dart';
import '../../../core/Constants/constants.dart';
import '../../../core/components/btn_widgets.dart';
import '../../../core/components/showSnackBar.dart';
import '../../../core/theme/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterOtpOfPhoneAuthScreen extends StatefulWidget {
  final String phoneNumber;
  final bool openAfterUserLogin;               // TODO : in this case will open Profile Screen
  const EnterOtpOfPhoneAuthScreen({super.key, required this.phoneNumber, required this.openAfterUserLogin});

  @override
  State<EnterOtpOfPhoneAuthScreen> createState() => _EnterOtpOfPhoneAuthScreenState();
}

class _EnterOtpOfPhoneAuthScreenState extends State<EnterOtpOfPhoneAuthScreen> {
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void dispose() {
    _pinCodeController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit cubit = AuthCubit.getInstance(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Otp"),
      ),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: ListView(
          padding: EdgeInsets.zero,
          children:
          [
            Text("Verification Code",style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold,color: AppColors.kBlack)),
            Text("Please type the verification code sent to ${widget.phoneNumber} ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,height: 1.6,color: AppColors.kLightGrey),),
            24.vrSpace,
            PinCodeTextField(
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                inactiveFillColor: const Color(0xffF3F8FF),
                borderRadius: BorderRadius.circular(4),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: AppColors.kMain,
                inactiveColor: Colors.grey.withOpacity(0.1),
                activeFillColor: Colors.transparent,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              controller: _pinCodeController,
              onCompleted: (v)
              {
                cubit.confirmPinCode(code: _pinCodeController.text.trim(),useWithLoginNotRegister: widget.openAfterUserLogin);
                debugPrint("---- Pin code is : ${_pinCodeController.text} -----");
              },
              appContext: context,
            ),
            12.vrSpace,
            BlocConsumer<AuthCubit,AuthStates>(
              listenWhen: (past,current) => current is ConfirmAuthOtpLoadingState || current is ConfirmAuthOtpWithFailureState || current is ConfirmAuthOtpSuccessfullyState,
              listener: (context,state)
              {
                if( state is ConfirmAuthOtpWithFailureState )
                {
                  showSnackBarWidget(message: state.message, successOrNot: false, context: context);
                }
                if( state is ConfirmAuthOtpSuccessfullyState )
                {
                  showSnackBarWidget(message: "Otp code confirmed successfully", successOrNot: true, context: context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> widget.openAfterUserLogin ? const ProfileScreen() : RegisterScreen(phoneNumber: widget.phoneNumber)), (_)=> true);
                }
              },
              builder: (context,state) => BtnWidget(
                minWidth: double.infinity,
                onTap: ()
                {
                  if( _pinCodeController.text.isEmpty )
                  {
                    showSnackBarWidget(message: "Please, Enter Otp code, try again !", successOrNot: false, context: context);
                  }
                  else
                  {
                    cubit.confirmPinCode(code: _pinCodeController.text.trim(),useWithLoginNotRegister: widget.openAfterUserLogin);
                  }
                },
                title: state is ConfirmAuthOtpLoadingState ? "Check Otp code loading" : "Continue",
              ),
            ),
            16.vrSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Text("Use another Phone number ?",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kDarkGrey),),
                6.hrSpace,
                InkWell(
                  onTap: ()
                  {
                    Navigator.pop(context);
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

