import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_event_customer/Screens/Auth/Welcome/components/background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "WELCOME TO GO-EVENT",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(80)),
              child: SvgPicture.asset("assets/icons/chat.svg",
                  height: getProportionateScreenHeight(350)),
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.of(context).pushNamed(Routes.login);
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              press: () {
                Navigator.of(context).pushNamed(Routes.signup);
              },
              color: kPrimaryLightColor,
              textColor: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
