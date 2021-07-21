import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';

void loadingSnackBar(
    {@required BuildContext context, @required String text, Color color}) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 320,
          child: Text(
            text,
            style: TextStyle(color: kPrimaryLightColor, fontSize: 15),
            maxLines: 2,
          ),
        ),
      ],
    ),
    backgroundColor: color == null ? kPrimaryColor : color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
