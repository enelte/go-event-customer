import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key key,
    this.width = 140,
    @required this.event,
  }) : super(key: key);

  final double width;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
      child: Container(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.event_details,
                arguments: {'event': event});
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Text(
                          event.eventName,
                          style: TextStyle(
                              color: kPrimaryLightColor,
                              fontSize: getProportionateScreenWidth(16)),
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        event.eventDate,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.w300,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: kPrimaryGradient,
              borderRadius: BorderRadius.circular(29),
            ),
          ),
        ),
      ),
    );
  }
}
