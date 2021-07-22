import 'package:flutter/material.dart';

import '../constant.dart';

class SwitchInput extends StatelessWidget {
  const SwitchInput({
    Key key,
    @required this.title,
    @required this.status,
    @required this.onChanged,
    @required this.trueValue,
    @required this.falseValue,
  });

  final String title;
  final String trueValue;
  final String falseValue;
  final bool status;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Switch(
                value: status,
                onChanged: onChanged,
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.redAccent,
                activeColor: kPrimaryLightColor,
              ),
              Text(
                status ? trueValue : falseValue,
                style:
                    TextStyle(color: status ? Colors.green : Colors.redAccent),
              ),
            ],
          )
        ],
      ),
    );
  }
}
