import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';

void loadingSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(color: kPrimaryLightColor, fontSize: 15),
        ),
        Container(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kPrimaryLightColor),
          ),
        )
      ],
    ),
    backgroundColor: kPrimaryColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
