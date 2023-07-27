import 'package:flutter/material.dart';
import 'package:hakathon_app/logic/provider/auth_provider.dart';
import 'package:hakathon_app/router/app_router.dart';
import 'package:hakathon_app/router/router_name.dart';
import 'package:hakathon_app/ui/shared/auth_custom_widget.dart';
import 'package:hakathon_app/ui/shared/cutom_button_widget.dart';
import 'package:hakathon_app/ui/shared/logo_widget.dart';
import 'package:hakathon_app/ui/shared/rich_text_custom.dart';
import 'package:hakathon_app/ui/shared/text_field_custom.dart';
import 'package:hakathon_app/utils/validation.dart';
import 'package:provider/provider.dart';

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
              const SizedBox(height: 60),
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
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
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
