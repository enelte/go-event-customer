import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/CreateService/components/venue.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/constant.dart';

class CreateServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = 1;
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text("Create Service"),
          backButton: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.location_city),
                text: "Venue",
              ),
              Tab(
                icon: Icon(Icons.music_note),
                text: "Talent",
              ),
              Tab(
                icon: Icon(Icons.fastfood),
                text: "Catering",
              ),
            ],
            indicatorWeight: 5,
            indicatorColor: kPrimaryLightColor,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Venue(),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: selectedIndex,
        ),
      ),
    );
  }
}
