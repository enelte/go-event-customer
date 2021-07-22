import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Profile/component/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = 3;
    final userData = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Profile", backButton: true),
      body: userData != null
          ? Body(
              userData: userData,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
      ),
    );
  }
}
