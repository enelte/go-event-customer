import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Login/components/background.dart';
import 'package:go_event_customer/components/already_have_an_account_acheck.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_event_customer/controllers/user_controller.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/validator.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(60),
                ),
                child: SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: getProportionateScreenHeight(300),
                ),
              ),
              RoundedInputField(
                hintText: "Your Email",
                controller: _emailController,
                validator: Validator.emailValidator,
              ),
              RoundedPasswordField(
                controller: _passwordController,
                validator: Validator.passwordValidator,
              ),
              RoundedButton(
                text: "LOGIN",
                press: () async {
                  if (_formKey.currentState.validate()) {
                    errorMessage = await signIn(
                        context,
                        _emailController.text.trim(),
                        _passwordController.text.trim());
                    setState(() {});
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(20)),
                child: Column(
                  children: [
                    if (errorMessage != "success" && errorMessage != null)
                      Text(
                        errorMessage.replaceAll("-", " "),
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.of(context).pushNamed(Routes.signup);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
