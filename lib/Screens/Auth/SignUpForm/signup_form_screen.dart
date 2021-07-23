import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/screens/Auth/SignUpForm/components/customer_signup.dart';
import 'package:go_event_customer/screens/Auth/SignUpForm/components/vendor_signup.dart';

class SignUpFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map roleMap = ModalRoute.of(context).settings.arguments;
    String role = roleMap['role'];
    return Scaffold(
      appBar: CustomAppBar(backButton: true,title:role == "customer" ? "SIGN UP AS CUSTOMER" : "SIGN UP AS VENDOR",actions: false,),
      body: role == "customer" ? CustomerSignUp() : VendorSignUp(),
    );
  }
}
