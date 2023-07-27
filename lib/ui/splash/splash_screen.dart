import 'package:flutter/material.dart';
import 'package:hakathon_app/logic/localData/shared_pref.dart';
import 'package:hakathon_app/router/app_router.dart';
import 'package:hakathon_app/router/router_name.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn =SharedPrefController().getLogedin();
    Future.delayed(
        const Duration(seconds: 2),
        () => AppRouter.goAndRemove(
              isLoggedIn? ScreenName.postScreen:ScreenName.singUpScreen,
            ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icons/logo.png',
        ),
      ),
    );
  }
}
