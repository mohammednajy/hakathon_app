import 'package:flutter/material.dart';
import 'package:hakathon_app/logic/localData/shared_pref.dart';
import 'package:hakathon_app/logic/provider/auth_provider.dart';
import 'package:hakathon_app/ui/auth/signup_screen.dart';
import 'package:hakathon_app/utils/validation.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../../router/router_name.dart';
import '../shared/auth_custom_widget.dart';
import '../shared/cutom_button_widget.dart';
import '../shared/logo_widget.dart';
import '../shared/rich_text_custom.dart';
import '../shared/text_field_custom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormFieldState> passKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogoWidget(),
              const AuthCustomWidget(
                firstText: 'Login',
                secondText:
                    'Fill the following information to access your account!',
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldCustom(
                fieldKey: passKey,
                controller: textEditingController,
                validator: (value) {
                  return value!.isValidEmail;
                },
                labelText: 'Email',
              ),
              const SizedBox(
                height: 50,
              ),
              CustomButtonWidget(
                isLoading: context.watch<AuthProvider>().isLoading,
                onPressed: () {
                  if (passKey.currentState!.validate()) {
                    context
                        .read<AuthProvider>()
                        .login(email: textEditingController.text);
                  }
                },
                text: 'Login',
              ),
              const SizedBox(
                height: 200,
              ),
              RichTextCustom(
                  leftText: 'Don\'t have an account?',
                  rightText: ' Sign up',
                  onTap: () => AppRouter.goTo(ScreenName.singUpScreen))
            ],
          ),
        ),
      ),
    );
  }
}
