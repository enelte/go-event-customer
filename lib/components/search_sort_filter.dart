import 'package:flutter/material.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import '../constant.dart';
import '../size_config.dart';

class SearchSortFilter extends StatelessWidget {
  const SearchSortFilter({
    Key key,
    this.onChanged,
    this.searchController,
    this.sort,
    this.filter,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final TextEditingController searchController;
  final Function sort;
  final Function filter;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height:77,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedInputField(
            icon: Icons.search,
            hintText: "Search",
            width: 250,
            onChanged: onChanged,
            controller: searchController,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: [
                IconButton(
                    icon: Icon(Icons.sort),
                    color: kPrimaryLightColor,
                    padding: EdgeInsets.only(top: 18),
                    constraints: BoxConstraints(),
                    onPressed: sort),
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
                icon: Icon(Icons.filter_alt),
                color: kPrimaryLightColor,
                padding: EdgeInsets.only(top: 18, bottom: 1),
                constraints: BoxConstraints(),
                onPressed: filter,
              ),
              Text(
                "Filter",
                style: TextStyle(
                    color: kPrimaryLightColor,
                    fontSize: getProportionateScreenWidth(10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
