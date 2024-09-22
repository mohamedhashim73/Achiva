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

class EnterPhoneAuthScreen extends StatefulWidget {
  const EnterPhoneAuthScreen({super.key});

  @override
  State<EnterPhoneAuthScreen> createState() => _EnterPhoneAuthScreenState();
}

class _EnterPhoneAuthScreenState extends State<EnterPhoneAuthScreen> {
  final TextEditingController _phoneNumController = TextEditingController();

  @override
  void dispose() {
    _phoneNumController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit cubit = AuthCubit.getInstance(context);
    return Scaffold(
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: ListView(
          padding: EdgeInsets.zero.copyWith(top: MediaQuery.of(context).padding.top + 34,bottom: 24),
          children:
          [
            const Text("Hello,\nEnter your Phone number",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,height: 1.6),),
            20.vrSpace,
            TextFieldWidget(controller: _phoneNumController,hint: "Phone Number", prefixIconData: Icons.phone,textInputType: TextInputType.number,),
            12.vrSpace,
            BlocConsumer<AuthCubit,AuthStates>(
              listenWhen: (past,current) => current is CodeAutoRetrievalTimeOuState || current is PhoneNumberVerifiedLoadingState || current is PhoneNumberVerifiedWithFailureState || current is PhoneNumberVerifiedSuccessfullyState,
              listener: (context,state)
              {
                if( state is PhoneNumberVerifiedWithFailureState )
                {
                  showSnackBarWidget(message: state.message, successOrNot: false, context: context);
                }
                if( state is PhoneNumberVerifiedSuccessfullyState )
                {
                  showSnackBarWidget(message: "Phone verified successfully", successOrNot: true, context: context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EnterOtpOfPhoneAuthScreen(openAfterUserLogin: false,phoneNumber: _phoneNumController.text.trim())));
                }
              },
              builder: (context,state) => BtnWidget(
                minWidth: double.infinity,
                onTap: ()
                {
                  if( _phoneNumController.text.isEmpty )
                  {
                    showSnackBarWidget(message: "Please, Enter Phone number, try again !", successOrNot: false, context: context);
                  }
                  else
                  {
                    cubit.verifyPhoneNumber(phoneNumber: _phoneNumController.text.trim());
                  }
                },
                title: state is PhoneNumberVerifiedLoadingState ? "Check Phone number loading" : "Continue",
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
      ),
    );
  }

}

