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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  @override
  void dispose() {
    nameEditingController.dispose();
    emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: SingleChildScrollView(
          child: Form(
            key: keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogoWidget(),
                const AuthCustomWidget(
                    firstText: 'Sign Up',
                    secondText:
                        'Fill the following information to create an account'),
                const SizedBox(
                  height: 20,
                ),
                TextFieldCustom(
                  controller: nameEditingController,
                  labelText: 'Name',
                  validator: (value) {
                    return value!.isValidName;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldCustom(
                  controller: emailEditingController,
                  labelText: 'Email',
                  validator: (value) {
                    return value!.isValidEmail;
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomButtonWidget(
                  isLoading: context.watch<AuthProvider>().isLoading,
                  onPressed: () {
                    if (keyForm.currentState!.validate()) {
                      context.read<AuthProvider>().singUp(
                          name: nameEditingController.text,
                          email: emailEditingController.text);
                    }
                  },
                  text: 'Sign up',
                ),
                const SizedBox(
                  height: 90,
                ),
                RichTextCustom(
                  leftText: ' Already have an account?  ',
                  rightText: 'Login',
                  onTap: () => AppRouter.goTo(ScreenName.loginScreen),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
