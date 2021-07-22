import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Auth/Login/components/background.dart';
import 'package:go_event_customer/components/already_have_an_account_acheck.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_event_customer/controllers/user_controller.dart';
import 'package:go_event_customer/popup_dialog.dart';
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
                "Forgot Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(40),
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
              RoundedButton(
                width: 270,
                text: "Send Password Reset Email",
                press: () {
                  PopUpDialog.confirmationDialog(
                      context: context,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          errorMessage = await sendPasswordResetEmail(
                            context,
                            _emailController.text.trim(),
                          ).then((value) {
                            loadingSnackBar(
                                context: context,
                                text: "Password Reset Email Send");
                            setState(() {});
                          }).catchError((e) {
                            loadingSnackBar(
                                context: context,
                                text: "An Error Ocurred",
                                color: Colors.red);
                          });
                        }
                      },
                      title: 'Send Password Reset Image?');
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(20)),
                child: Column(
                  children: [
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          width: 270,
                          child: Text(
                            errorMessage.replaceAll("-", " "),
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.of(context).pushNamed(Routes.signup);
                      },
                    )
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
