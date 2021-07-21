import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Home/components/slider_list.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    return MainBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userData != null && userData.role == "Customer")
                WhatAreYouLookingFor(userData: userData),
              if (userData != null)
                SliderList(
                    title: userData.role == "Customer"
                        ? "Find Services"
                        : "Your Services",
                    type: "service"),
              SizedBox(height: 25),
              if (userData != null)
                SliderList(
                    title: userData.role == "Customer"
                        ? "Your Orders"
                        : "Incoming Orders",
                    type: "order")
            ],
          ),
        ),
      ),
    );
  }
}

class WhatAreYouLookingFor extends StatelessWidget {
  const WhatAreYouLookingFor({
    Key key,
    @required this.userData,
  }) : super(key: key);

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Hi " +
                (userData != null ? userData.displayName.split(" ")[0] : "") +
                ", what are you looking for?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CategoriesCard(
              icon: Icons.home,
              text: 'Venue',
              press: () {
                Service filter = new Service(serviceName: "Venue");
                Navigator.pushNamed(context, Routes.service,
                    arguments: {'filter': filter});
              },
            ),
            CategoriesCard(
              icon: Icons.music_note,
              text: 'Talents',
              press: () {
                Service filter = new Service(serviceName: "Talent");
                Navigator.pushNamed(context, Routes.service,
                    arguments: {'filter': filter});
              },
            ),
            CategoriesCard(
              icon: Icons.fastfood,
              text: 'Catering',
              press: () {
                Service filter = new Service(serviceName: "Catering");
                Navigator.pushNamed(context, Routes.service,
                    arguments: {'filter': filter});
              },
            ),
          ],
        ),
      ],
    );
  }
}

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({
    Key key,
    this.icon,
    this.text,
    this.press,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(60.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFFFECDF),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: Icon(icon),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 20,
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
