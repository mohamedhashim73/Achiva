import 'package:achiva/controllers/layout_controller/layout_cubit.dart';
import 'package:achiva/controllers/layout_controller/layout_states.dart';
import 'package:achiva/core/Constants/constants.dart';
import 'package:achiva/core/components/textField_widget.dart';
import 'package:achiva/core/constants/extensions.dart';
import 'package:achiva/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/btn_widgets.dart';
import '../../../core/components/showSnackBar.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete User account"),
      ),
      body: ListView(
        padding: AppConstants.kScaffoldPadding.copyWith(bottom: 24),
        children: [
          TextFieldWidget(controller: _emailController, hint: "Type your Email", prefixIconData: Icons.email,textInputAction: TextInputAction.next,),
          TextFieldWidget(controller: _passwordController, hint: "Type your current Password", prefixIconData: Icons.password,secureTxt: true),
          8.vrSpace,
          BlocConsumer<LayoutCubit,LayoutStates>(
            listenWhen: (past,current) => current is DeleteAccountWithFailureState || current is DeleteAccountSuccessfullyState || current is DeleteAccountLoadingState,
            listener: (context,state)
            {
              if( state is DeleteAccountWithFailureState )
              {
                showSnackBarWidget(message: state.message, successOrNot: false, context: context);
              }
              if( state is DeleteAccountSuccessfullyState )
              {
                showSnackBarWidget(message: "Account Deleted Successfully", successOrNot: true, context: context);
                Navigator.pushNamedAndRemoveUntil(context, AppStrings.kLoginScreenName, (_)=> true);
              }
            },
            builder: (context,state) => BtnWidget(
              minWidth: double.infinity,
              onTap: ()
              {
                if( _passwordController.text.isNotEmpty && _emailController.text.isNotEmpty )
                {
                  layoutCubit.deleteAccount(email: _emailController.text.trim(),password: _passwordController.text.trim());
                }
                else
                {
                  showSnackBarWidget(message: "Firstly, type your password to be able to delete account!", successOrNot: false, context: context);
                }
              },
              title: state is DeleteAccountLoadingState ? "Delete user account loading" : "Delete account",
            ),
          ),
        ],
      ),
    );
  }
}
