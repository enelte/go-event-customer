import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/controllers/service_controller.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({Key key});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    Service service = serviceMap['service'];
    UserModel vendor = serviceMap['vendor'];
    return Scaffold(
      appBar: CustomAppBar(title: service.serviceName, backButton: true),
      body: Body(
        service: service,
        vendor: vendor,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: user.role == "Vendor"
          ? FloatingActionButton(
              heroTag: "delete",
              onPressed: () {
                loadingSnackBar(context: context, text: "Service Deleted");
                deleteService(context, service)
                    .whenComplete(() => Navigator.of(context).pop());
              },
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
            )
          : null,
    );
  }
}
