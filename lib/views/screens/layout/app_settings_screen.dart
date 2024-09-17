import 'package:achiva/controllers/layout_controller/layout_cubit.dart';
import 'package:achiva/controllers/layout_controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Constants/constants.dart';
import '../../../core/constants/strings.dart';
import '../../widgets/profile_widgets/listTileWidget.dart';
import 'edit_profile_screen.dart';

class AppSettingsScreen extends StatelessWidget {
  final LayoutCubit layoutCubit;
  const AppSettingsScreen({super.key, required this.layoutCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTileWidget(
              onTap: (){
                Navigator.pushNamed(context, AppStrings.kNotificationsScreenName);
              },
              title: "Notifications",
              leadingIconData: Icons.notification_important,
            ),
            ListTileWidget(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileScreen(layoutCubit: layoutCubit)));
                },
                title: "Edit Profile",
                leadingIconData: Icons.account_circle
            ),
            ListTileWidget(
                onTap: ()
                {
                  Navigator.pushNamed(context, AppStrings.kChangeUserEmailScreenName);
                },
                title: "Change Email",
                leadingIconData: Icons.email
            ),
            ListTileWidget(
                onTap: ()
                {
                  Navigator.pushNamed(context, AppStrings.kChangeUserPasswordScreenName);
                },
                title: "Change Password",
                leadingIconData: Icons.password
            ),
            ListTileWidget(
              onTap: (){
                Navigator.pushNamed(context, AppStrings.kDeleteAccountScreenName);
              },
              title: "Delete Account",
              leadingIconData: Icons.delete,
            ),
            BlocListener<LayoutCubit,LayoutStates>(
              listenWhen: (past,currentState) => currentState is SignOutSuccessfullyState,
              listener: (context,state){
                if( state is SignOutSuccessfullyState )
                  {
                    Navigator.pushNamedAndRemoveUntil(context, AppStrings.kLoginScreenName, (_)=> true);
                  }
              },
              child: ListTileWidget(
                onTap: (){
                  layoutCubit.signOut(notToEmitToState: false);
                },
                title: "Sign Out",
                leadingIconData: Icons.login_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
