import 'package:flutter/material.dart';


class AuthCustomWidget extends StatelessWidget {
  const AuthCustomWidget({
    Key? key,
    required this.firstText,
    required this.secondText,
  }) : super(key: key);
  final String firstText;
  final String secondText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstText,
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Colors.black,
              ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          secondText,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.black,
              ),
        ),
      ],
    );
  }
}
