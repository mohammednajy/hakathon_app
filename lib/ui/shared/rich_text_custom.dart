import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/constant.dart';


class RichTextCustom extends StatelessWidget {
  const RichTextCustom({
    required this.leftText,
    required this.rightText,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String leftText;
  final String rightText;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: leftText,
          style: const TextStyle(color: Colors.black, fontSize: 17),
          children: [
            TextSpan(
              text: rightText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: blueColor,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            )
          ],
        ),
      ),
    );
  }
}
