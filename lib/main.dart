import 'package:achiva/core/constants/bloc_observer.dart';
import 'package:achiva/core/constants/constants.dart';
import 'package:achiva/core/constants/strings.dart';
import 'package:achiva/core/network/cache_network.dart';
import 'package:achiva/core/theme/app_theme.dart';
import 'package:achiva/views/screens/auth/login_screen.dart';
import 'package:achiva/views/screens/layout/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.cacheInitialization();
  Bloc.observer = MyBlocObserver();
  AppConstants.kUserID = CacheHelper.getString(key: AppStrings.kUserIDName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: AppConstants.kProviders,
        child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
            child: MaterialApp(
                theme: AppTheme.light,
                debugShowCheckedModeBanner: false,
                routes: AppConstants.kRoutes,
                home: AppConstants.kUserID != null ? const ProfileScreen() : const LoginScreen()
            )
        )
    );
  }
}

