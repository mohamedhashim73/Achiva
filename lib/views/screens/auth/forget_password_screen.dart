import 'package:achiva/controllers/auth_controller/auth_cubit.dart';
import 'package:achiva/controllers/auth_controller/auth_states.dart';
import 'package:achiva/controllers/layout_controller/layout_cubit.dart';
import 'package:achiva/core/Constants/constants.dart';
import 'package:achiva/core/components/awesome_dialog_widget.dart';
import 'package:achiva/core/components/textField_widget.dart';
import 'package:achiva/core/constants/extensions.dart';
import 'package:achiva/core/constants/strings.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/btn_widgets.dart';
import '../../../core/components/showSnackBar.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = AuthCubit.getInstance(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send password reset email"),
      ),
      body: ListView(
        padding: AppConstants.kScaffoldPadding.copyWith(bottom: 24),
        children: [
          TextFieldWidget(controller: _emailController, hint: "Type your Email", prefixIconData: Icons.email),
          8.vrSpace,
          BlocConsumer<AuthCubit,AuthStates>(
            listenWhen: (past,current) => current is SendPasswordResetEmailWithFailureState || current is SendPasswordResetEmailSuccessfullyState || current is SendPasswordResetEmailLoadingState,
            listener: (context,state)
            {
              if( state is SendPasswordResetEmailWithFailureState )
              {
                showSnackBarWidget(message: state.message, successOrNot: false, context: context);
              }
              if( state is SendPasswordResetEmailSuccessfullyState )
              {
                showAwesomeDialogWidget(showOnlyOkBtn: true,title: "Reset password",desc: "Check your Gmail, you can now reset your password throw the link which sent to you.", context: context, type: DialogType.success,okBtnMethod: (){
                  Navigator.pushNamed(context,AppStrings.kLoginScreenName);
                });
              }
            },
            builder: (context,state) => BtnWidget(
              minWidth: double.infinity,
              onTap: ()
              {
                if( _emailController.text.isNotEmpty )
                {
                  authCubit.forgetPassword(email: _emailController.text.trim());
                }
                else
                {
                  showSnackBarWidget(message: "Firstly, type your Email to continue!", successOrNot: false, context: context);
                }
              },
              title: state is SendPasswordResetEmailLoadingState ? "Send password reset email loading" : "Confirm",
            ),
          ),
        ],
      ),
    );
  }
}
