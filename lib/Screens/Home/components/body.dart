import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Home/components/slider_list.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/size_config.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text(
                  "What are you looking for?",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoriesCard(
                    icon: Icons.home,
                    text: 'Venue',
                    press: () {},
                  ),
                  CategoriesCard(
                    icon: Icons.music_note,
                    text: 'Talents',
                    press: () {},
                  ),
                  CategoriesCard(
                    icon: Icons.fastfood,
                    text: 'Catering',
                    press: () {},
                  ),
                ],
              ),
              //SliderList(title: "Your Services", type: "service"),
              //SizedBox(height: 25),
              //SliderList(title: "Your Orders", type: "order")
            ],
          ),
        ),
      ),
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
