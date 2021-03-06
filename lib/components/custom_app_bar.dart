import 'package:flutter/material.dart';
import 'package:go_event_customer/controllers/user_controller.dart';

import '../constant.dart';
import '../size_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Widget bottom;
  const CustomAppBar({this.title, this.backButton = false, this.bottom});

  @override
  Size get preferredSize => Size.fromHeight(bottom != null
      ? getProportionateScreenHeight(140)
      : getProportionateScreenHeight(70));
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: kPrimaryGradient),
      ),
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text("Go-Event"),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
          )
        ],
      ),
      leading: backButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              color: kPrimaryLightColor,
              onPressed: () {
                Navigator.pop(context, false);
              },
            )
          : Container(),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          color: kPrimaryLightColor,
          onPressed: () {
            signOut(context);
          },
        ),
      ],
      bottom: bottom,
    );
  }
}
