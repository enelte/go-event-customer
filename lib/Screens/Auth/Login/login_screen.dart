import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Auth/Login/components/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButton: true,title:"LOGIN",actions: false,),
      body: Body(),
    );
  }
}
