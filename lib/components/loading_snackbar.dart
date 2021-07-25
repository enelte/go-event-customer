import 'package:flutter/material.dart';
import 'package:go_event_customer/size_config.dart';

void loadingSnackBar(
    {@required BuildContext context, @required String text, Color color}) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: getProportionateScreenWidth(300),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16,),
            maxLines: 2,
          ),
        ),
        Container(
          width: getProportionateScreenWidth(25),
          child: Icon(color==null?Icons.verified:Icons.warning, color: Colors.white),
          ),
        
      ],
    ),
    backgroundColor: color == null ? Colors.green : color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
