import 'package:achiva/controllers/layout_controller/layout_cubit.dart';
import 'package:achiva/controllers/layout_controller/layout_states.dart';
import 'package:achiva/core/Constants/constants.dart';
import 'package:achiva/core/components/textField_widget.dart';
import 'package:achiva/core/constants/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/btn_widgets.dart';
import '../../../core/components/showSnackBar.dart';

class ChangeUserPasswordScreen extends StatefulWidget {
  const ChangeUserPasswordScreen({super.key});

  @override
  State<ChangeUserPasswordScreen> createState() => _ChangeUserPasswordScreenState();
}

class _ChangeUserPasswordScreenState extends State<ChangeUserPasswordScreen> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change User Password"),
      ),
      body: ListView(
        padding: AppConstants.kScaffoldPadding.copyWith(bottom: 24),
        children: [
          TextFieldWidget(controller: _currentPassword, hint: "Type your Email", prefixIconData: Icons.email,textInputAction: TextInputAction.next,),
          TextFieldWidget(controller: _currentPassword, hint: "Type your current Password", prefixIconData: Icons.password,secureTxt: true,textInputAction: TextInputAction.next,),
          TextFieldWidget(controller: _newPassword, hint: "Type your new Password", prefixIconData: Icons.password,secureTxt: true,),
          8.vrSpace,
          BlocConsumer<LayoutCubit,LayoutStates>(
            listenWhen: (past,current) => current is ChangePasswordWithFailureState || current is ChangePasswordSuccessfullyState || current is ChangePasswordLoadingState,
            listener: (context,state)
            {
              if( state is ChangePasswordWithFailureState )
              {
                showSnackBarWidget(message: state.message, successOrNot: false, context: context);
              }
              if( state is ChangePasswordSuccessfullyState )
              {
                showSnackBarWidget(message: "Password changed successfully", successOrNot: true, context: context);
                Navigator.pop(context);
              }
            },
            builder: (context,state) => BtnWidget(
              minWidth: double.infinity,
              onTap: ()
              {
                if( _currentPassword.text.isNotEmpty && _newPassword.text.isNotEmpty && _emailController.text.isNotEmpty )
                {
                  layoutCubit.changeUserPassword(email: _emailController.text.trim(),currentPassword: _currentPassword.text.trim(),newPassword: _newPassword.text.trim());
                }
                else
                {
                  showSnackBarWidget(message: "Please, fill Data and try again !", successOrNot: false, context: context);
                }
              },
              title: state is ChangePasswordLoadingState ? "Change user password loading" : "Change",
            ),
          ),
        ],
      ),
    );
  }
}
