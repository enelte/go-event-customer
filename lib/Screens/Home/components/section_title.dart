import 'package:flutter/material.dart';
import 'package:go_event_customer/size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({Key key, this.title, this.press}) : super(key: key);

  @required
  final String title;
  @required
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.black,
            )),
        GestureDetector(
            onTap: press,
            child: Text(
              "See More",
              style: TextStyle(color: Color(0xFFBBBBBB)),
            ))
      ],
    );
  }
}
