import 'package:flutter/material.dart';
import 'package:go_event_customer/routes.dart';

import '../constant.dart';
import '../size_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final bool actions;
  final Widget bottom;
  const CustomAppBar(
      {this.title, this.backButton = false, this.bottom, this.actions = true});

  @override
  Size get preferredSize => Size.fromHeight(bottom != null
      ? 140
      : 70);
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
          Text(
            title.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize:getProportionateScreenWidth(14)),
            maxLines: 2,
          )
        ],
      ),
      leading: backButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: kPrimaryLightColor,
              onPressed: () {
                Navigator.pop(context, false);
              },
            )
          : Container(),
      actions: [
        if (actions)
          IconButton(
            icon: Icon(Icons.person),
            color: kPrimaryLightColor,
            onPressed: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
      ],
      bottom: bottom,
    );
  }
}
