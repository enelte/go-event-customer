import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';

import 'component/body.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = 2;
    return Scaffold(
      appBar: CustomAppBar(title: "My Events"),
      body: Body(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
      ),
    );
  }
}
