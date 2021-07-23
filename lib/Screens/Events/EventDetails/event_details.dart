import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/routes.dart';

import 'components/body.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({Key key});
  @override
  Widget build(BuildContext context) {
    final Map map = ModalRoute.of(context).settings.arguments;
    Event event = map['event'];
    return Scaffold(
      appBar: CustomAppBar(title: "Event Details", backButton: true),
      body: Body(event: event),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        heroTag: "addService",
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.service,
          );
        },
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
