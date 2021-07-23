import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Auth/Login/components/background.dart';
import 'package:go_event_customer/components/already_have_an_account_acheck.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:flutter_svg/svg.dart';
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
    
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(40),
              ),
              child: SvgPicture.asset(
                "assets/icons/signup.svg",
                height: getProportionateScreenHeight(300),
              ),
            ),
            RoundedButton(
              width: 270,
              text: "SIGN UP AS CUSTOMER",
              press: () {
                Navigator.of(context).pushNamed(Routes.signup_form,
                    arguments: {"role": "customer"});
              },
            ),
            Text(
              "OR",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RoundedButton(
              width: 270,
              text: "SIGN UP AS VENDOR",
              press: () {
                Navigator.of(context).pushNamed(Routes.signup_form,
                    arguments: {"role": "vendor"});
              },
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).pushNamed(Routes.login);
              },
            ),
            Container(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "You can not use same email address to sign up as both customer and vendor",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
