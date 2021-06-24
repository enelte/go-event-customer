import 'package:flutter/material.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import '../constant.dart';
import '../size_config.dart';

class SearchSortFilter extends StatelessWidget {
  const SearchSortFilter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedInputField(
          icon: Icons.search,
          hintText: "Search",
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              IconButton(
                  icon: Icon(Icons.sort),
                  color: kPrimaryLightColor,
                  padding: EdgeInsets.only(top: 10),
                  constraints: BoxConstraints(),
                  onPressed: () {}),
              Text(
                "Sort",
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontSize: getProportionateScreenWidth(10),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            IconButton(
                icon: Icon(Icons.filter),
                color: kPrimaryLightColor,
                padding: EdgeInsets.only(top: 10, bottom: 1),
                constraints: BoxConstraints(),
                onPressed: () {}),
            Text(
              "Filter",
              style: TextStyle(
                  color: kPrimaryLightColor,
                  fontSize: getProportionateScreenWidth(10)),
            ),
          ],
        ),
      ],
    );
  }
}
