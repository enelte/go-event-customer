import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Settings/components/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile Settings",
        backButton: true,
        actions: false,
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
