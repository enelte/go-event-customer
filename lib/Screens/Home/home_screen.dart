import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Home/components/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';

import '../../size_config.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = 0;
    SizeConfig().init(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "GO EVENT",
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
      ),
    );
  }
}
