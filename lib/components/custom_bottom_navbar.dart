import 'package:flutter/material.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/size_config.dart';
import '../constant.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key key, this.currentIndex})
      : super(key: key);
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: getProportionateScreenHeight(85),
        decoration: BoxDecoration(gradient: kPrimaryGradient),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconWithText(
                text: "Home",
                icon: Icons.home,
                routes: Routes.home,
                isCurrent: currentIndex == 0),
            IconWithText(
                text: "My Bookings",
                icon: Icons.shopping_bag,
                routes: Routes.transaction,
                isCurrent: currentIndex == 1),
            IconWithText(
                text: "Find Service",
                icon: Icons.family_restroom,
                routes: Routes.service,
                isCurrent: currentIndex == 4),
            IconWithText(
                text: "My Events",
                icon: Icons.calendar_today,
                routes: Routes.event,
                isCurrent: currentIndex == 2),
            IconWithText(
                text: "My Profile",
                icon: Icons.person,
                routes: Routes.profile,
                isCurrent: currentIndex == 3),
          ],
        ));
    // return BottomNavigationBar(
    //   items: const <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    //     BottomNavigationBarItem(
    //         icon: Icon(Icons.room_service), label: "My Service"),
    //     BottomNavigationBarItem(icon: Icon(Icons.event), label: "Orders"),
    //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
    //   ],
    //   currentIndex: currentIndex,
    //   type: BottomNavigationBarType.fixed,
    //   fixedColor: kPrimaryColor,
    //   onTap: onTap,
    // );
  }
}

class IconWithText extends StatelessWidget {
  const IconWithText(
      {Key key, this.text, this.icon, this.routes, this.isCurrent})
      : super(key: key);
  final String text;
  final IconData icon;
  final String routes;
  final bool isCurrent;
  @override
  Widget build(BuildContext context) {
    Color color;
    isCurrent ? color = Colors.white : color = Colors.white38;
    return Container(
      width: 75,
      decoration: isCurrent
          ? BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white,
                  width: 4,
                ),
              ),
            )
          : BoxDecoration(),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
            icon: Icon(icon, size: 30),
            color: color,
            constraints: BoxConstraints(),
            onPressed: isCurrent
                ? () {}
                : () {
                    Navigator.pushNamed(context, routes);
                  }),
        Text(
          text,
          style: TextStyle(
              color: color,
              fontSize: getProportionateScreenWidth(11),
              fontWeight: FontWeight.w400),
        )
      ]),
    );
  }
}
