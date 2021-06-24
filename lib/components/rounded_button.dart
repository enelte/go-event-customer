import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';

import '../size_config.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double width;

  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.width = 220,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: getProportionateScreenWidth(width),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: color,
          ),
          onPressed: press,
          child: Text(text, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}
