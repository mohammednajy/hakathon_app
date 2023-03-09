import 'package:flutter/material.dart';

import '../../utils/constant.dart';


class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    Key? key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
  }) : super(key: key);

  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45),
        shadowColor: blueColor,
        primary: blueColor,
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
    );
  }
}
