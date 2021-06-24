import 'package:flutter/material.dart';
import 'package:go_event_customer/size_config.dart';

class MainBackground extends StatelessWidget {
  final Widget child;
  const MainBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: getProportionateScreenHeight(SizeConfig.screenHeight),
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/signup_top.png",
              width: getProportionateScreenWidth(70),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: getProportionateScreenWidth(50),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
