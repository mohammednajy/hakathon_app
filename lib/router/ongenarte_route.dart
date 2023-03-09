import 'package:flutter/material.dart';
import 'package:hakathon_app/logic/provider/auth_provider.dart';
import 'package:hakathon_app/logic/provider/post_provider.dart';
import 'package:hakathon_app/router/router_name.dart';
import 'package:hakathon_app/ui/auth/signup_screen.dart';
import 'package:hakathon_app/ui/post/post_screen.dart';
import 'package:hakathon_app/ui/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import '../ui/auth/login_screen.dart';

Route onGenerateRoute(RouteSettings settings) {
  dynamic result;
  switch (settings.name) {
    case ScreenName.splashScreen:
      result = const SplashScreen();
      break;
    case ScreenName.loginScreen:
      result = ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: const LoginScreen(),
      );
      break;
    case ScreenName.singUpScreen:
      result = ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: const SignUpScreen(),
      );
      break;
    case ScreenName.postScreen:
      result =  const PostScreen();
      break;
    default:
      const Scaffold(
        body: Center(child: Text('error path')),
      );
  }
  return MaterialPageRoute(
    builder: (context) => result,
  );
}
