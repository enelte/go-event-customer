import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Auth/SignUp/components/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButton: true,title:"SIGN UP",actions: false,),
      body: Body(),
    );
  }
}
