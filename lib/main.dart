import 'package:flutter/material.dart';
import 'package:hakathon_app/logic/provider/post_provider.dart';
import 'package:hakathon_app/router/app_router.dart';
import 'package:hakathon_app/router/ongenarte_route.dart';
import 'package:hakathon_app/router/router_name.dart';
import 'package:hakathon_app/utils/helper.dart';
import 'package:provider/provider.dart';

import 'logic/localData/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().init();
  runApp(ChangeNotifierProvider(
    create: (context) => PostProvider(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: UtilsConfig.scaffoldKey,
      debugShowCheckedModeBanner: false,
      initialRoute: ScreenName.splashScreen,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: AppRouter.navigationKey,
    );
  }
}
