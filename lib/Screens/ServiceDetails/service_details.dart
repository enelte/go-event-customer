import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/ServiceDetails/components/venue_details.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/routes.dart';

import 'components/body.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({Key key});
  @override
  Widget build(BuildContext context) {
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    Service service = serviceMap['service'];
    return Scaffold(
      appBar: CustomAppBar(title: "Service Details", backButton: true),
      body: Body(service: service),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "gallery",
            onPressed: () {
              Navigator.pushNamed(context, Routes.service_gallery,
                  arguments: {'serviceId': service.serviceId});
            },
            child: Icon(Icons.add_a_photo),
            backgroundColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
