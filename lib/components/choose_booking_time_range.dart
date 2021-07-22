import 'package:flutter/material.dart';
import 'package:go_event_customer/components/time_range.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/text_formatter.dart';

class ChooseBookingTimeRange extends StatelessWidget {
  const ChooseBookingTimeRange(
      {Key key,
      @required this.service,
      @required this.onRangeCompleted,
      this.initialRange})
      : super(key: key);

  final Service service;
  final Function onRangeCompleted;
  final TimeRangeResult initialRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 67, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.timer),
              SizedBox(width: 10),
              Text(
                "Booking Time",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ],
          ),
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
              firstTime:
                  TextFormatter.stringToTimeOfDay(service.startServiceTime),
              lastTime: TextFormatter.stringToTimeOfDay(service.endServiceTime)
                  .replacing(minute: 1),
              initialRange: initialRange,
              timeStep: 60,
              timeBlock: 60,
              minRange:
                  service.serviceType != "Catering" ? service.minOrder : 1,
              maxRange:
                  service.serviceType != "Catering" ? service.maxOrder + 1 : 0,
              onRangeCompleted: onRangeCompleted),
        ),
      ],
    );
  }
}
