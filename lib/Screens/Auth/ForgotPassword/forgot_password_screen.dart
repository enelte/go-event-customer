import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Auth/ForgotPassword/components/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButton: true,title:"FORGOT PASSWORD",actions: false,),
      body: Body(),
    );
  }
}
