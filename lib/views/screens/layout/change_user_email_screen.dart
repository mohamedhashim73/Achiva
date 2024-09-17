import 'package:achiva/controllers/layout_controller/layout_cubit.dart';
import 'package:achiva/controllers/layout_controller/layout_states.dart';
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

class ChangeUserEmailScreen extends StatefulWidget {
  const ChangeUserEmailScreen({super.key});

  @override
  State<ChangeUserEmailScreen> createState() => _ChangeUserEmailScreenState();
}

class _ChangeUserEmailScreenState extends State<ChangeUserEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change User Email"),
      ),
      body: ListView(
        padding: AppConstants.kScaffoldPadding.copyWith(bottom: 24),
        children: [
          TextFieldWidget(controller: _emailController, hint: "Type your new Email", prefixIconData: Icons.email,textInputAction: TextInputAction.next,),
          TextFieldWidget(controller: _passwordController, hint: "Type your current Password", prefixIconData: Icons.password,secureTxt: true,),
          8.vrSpace,
          BlocConsumer<LayoutCubit,LayoutStates>(
            listenWhen: (past,current) => current is ChangeUserEmailWithFailureState || current is ChangeUserEmailSuccessfullyState || current is ChangeUserEmailLoadingState,
            listener: (context,state)
            {
              if( state is ChangeUserEmailWithFailureState )
              {
                showSnackBarWidget(message: state.message, successOrNot: false, context: context);
              }
              if( state is ChangeUserEmailSuccessfullyState )
              {
                Future.delayed(const Duration(seconds: 5),()=> Navigator.pushNamedAndRemoveUntil(context, AppStrings.kLoginScreenName, (_)=> true));
                showAwesomeDialogWidget(showOnlyOkBtn: true,title: "Email verification Sent Successfully",desc: "Check your Gmail as We sent an email verification to be able to use it on App.", context: context, type: DialogType.success);
              }
            },
            builder: (context,state) => BtnWidget(
              minWidth: double.infinity,
              onTap: ()
              {
                if( _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty )
                {
                  layoutCubit.changeUserEmail(email: _emailController.text.trim(),password: _passwordController.text.trim());
                }
                else
                {
                  showSnackBarWidget(message: "Please, fill Data and try again !", successOrNot: false, context: context);
                }
              },
              title: state is ChangeUserEmailLoadingState ? "Change user email loading" : "Change",
            ),
          ),
        ],
      ),
    );
  }
}
