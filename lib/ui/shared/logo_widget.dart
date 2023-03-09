import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Center(
          child: Image.asset(
            'assets/icons/logo.png',
            height: 70,
            width: 70,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
