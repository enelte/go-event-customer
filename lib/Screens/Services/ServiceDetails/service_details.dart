import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/controllers/service_controller.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/ServiceType.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({Key key});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    final database = Provider.of<FirestoreService>(context);
    Service service = serviceMap['service'];
    UserModel vendor = serviceMap['vendor'];
    List<Transaction> transactionList = serviceMap['transactionList'];
    return Scaffold(
      appBar: CustomAppBar(title: service.serviceName, backButton: true),
      body: StreamBuilder<Object>(
          stream: database.serviceTypesStream(
              queryBuilder: (query) =>
                  query.where("name", isEqualTo: service.serviceType)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ServiceType> typeList = snapshot.data;
              ServiceType type = typeList.first;
              return Body(
                service: service,
                vendor: vendor,
                serviceType: type,
              );
            } else if (snapshot.hasError) {
              return Text("No Data Available");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: user.role == "Vendor"
          ? FloatingActionButton(
              heroTag: "delete",
              onPressed: () {
                PopUpDialog.confirmationDialog(
                    context: context,
                    onPressed: () async {
                      print(transactionList.length);
                      if (transactionList.length > 0) {
                        loadingSnackBar(
                            context: context,
                            text:
                                "Can't Delete Service : There are On Going Orders on this service",
                            color: Colors.red);
                      } else {
                        loadingSnackBar(
                            context: context, text: "Service Deleted");
                        await deleteService(context, service)
                            .then((value) => Navigator.of(context).pop())
                            .catchError((e) {
                          loadingSnackBar(
                              context: context,
                              text: "An Error Occurred",
                              color: Colors.red);
                        });
                      }
                    },
                    title: "Are you sure want to delete the service?");
              },
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
            )
          : null,
    );
  }
}
