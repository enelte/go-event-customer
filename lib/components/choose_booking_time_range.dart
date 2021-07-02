import 'package:flutter/material.dart';
import 'package:go_event_customer/components/time_range.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';

class ChooseBookingTimeRange extends StatelessWidget {
  const ChooseBookingTimeRange(
      {Key key, @required this.service, @required this.onRangeCompleted})
      : super(key: key);

  final Service service;
  final Function onRangeCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Booking Time",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
          child: TimeRange(
              fromTitle: Text(
                'From',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              toTitle: Text(
                'To',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              titlePadding: 20,
              textStyle: TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black87),
              activeTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              borderColor: Colors.black,
              backgroundColor: Colors.transparent,
              activeBackgroundColor: kPrimaryColor,
              firstTime: TimeOfDay(hour: 8, minute: 00),
              lastTime: TimeOfDay(hour: 22, minute: 01),
              timeStep: 60,
              timeBlock: 60,
              minRange: service.minOrder,
              maxRange: service.maxOrder + 1,
              onRangeCompleted: onRangeCompleted),
        ),
      ],
    );
  }
}
