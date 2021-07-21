import 'package:flutter/material.dart';
import 'package:go_event_customer/screens/Auth/SignUpForm/components/customer_signup.dart';
import 'package:go_event_customer/screens/Auth/SignUpForm/components/vendor_signup.dart';

class SignUpFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map roleMap = ModalRoute.of(context).settings.arguments;
    String role = roleMap['role'];
    return Scaffold(
      body: role == "customer" ? CustomerSignUp() : VendorSignUp(),
    );
  }
}
