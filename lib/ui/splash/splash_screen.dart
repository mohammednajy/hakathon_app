import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../router/router_name.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 2),
        () => AppRouter.goAndRemove(
              ScreenName.singUpScreen,
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
