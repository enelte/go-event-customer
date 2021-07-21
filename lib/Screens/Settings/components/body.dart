import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Auth/Login/components/background.dart';
import 'package:go_event_customer/components/display_name.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/controllers/user_controller.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/auth_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loggedUser =
        Provider.of<FirebaseAuthService>(context).getCurrentUser();
    final loggedUserData = Provider.of<UserModel>(context);
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProfilePic(
              imageURL: loggedUserData.photoURL,
            ),
            displayName(loggedUserData.displayName, loggedUser.email,
                "+62" + loggedUserData.phoneNumber),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              width: 270,
              text: "Edit Profile",
              press: () {
                Navigator.pushNamed(context, Routes.profile);
              },
            ),
            RoundedButton(
              width: 270,
              text: "Change Password",
              press: () async {
                errorMessage = await sendPasswordResetEmail(
                        context, loggedUser.email) +
                    ". Please logout and login with your new password afterwards";
                setState(() {});
              },
            ),
            RoundedButton(
              width: 270,
              text: "Log Out",
              press: () {
                PopUpDialog.logOutDialog(context);
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
