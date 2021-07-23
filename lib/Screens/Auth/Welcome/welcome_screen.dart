import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Auth/Welcome/components/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/size_config.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
       appBar: CustomAppBar(title:"WELCOME TO GO-EVENT",actions: false,),
      body: Body(),
    );
  }
}
