import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/ServiceDetails/components/venue_details.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firebase_storage_service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({Key key});
  @override
  Widget build(BuildContext context) {
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    Service service = serviceMap['service'];
    return Scaffold(
      appBar: CustomAppBar(title: Text("Service Details"), backButton: true),
      body: service.serviceType == "Venue"
          ? VenueDetails(
              service: service,
            )
          : service.serviceType == "Talent"
              ? VenueDetails(
                  service: service,
                )
              : VenueDetails(
                  service: service,
                ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "delete",
            onPressed: () {
              loadingSnackBar(context, "Deleting Service...");
              deleteService(context, service)
                  .whenComplete(() => Navigator.of(context).pop());
            },
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 20),
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

Future deleteService(BuildContext context, Service service) async {
  final storage = Provider.of<FirebaseStorageService>(context, listen: false);
  final database = Provider.of<FirestoreService>(context, listen: false);
  if (service.images != null) {
    for (var image in service.images) {
      await storage.deleteImage(imageURL: image);
    }
  }
  await database.deleteService(service);
}
