import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({Key key});
  @override
  Widget build(BuildContext context) {
    final Map map = ModalRoute.of(context).settings.arguments;
    Event event = map['event'];
    final database = Provider.of<FirestoreService>(context);
    return StreamBuilder<Object>(
        stream: database.transactionsStream(
          queryBuilder: (query) =>
              query.where("eventId", isEqualTo: event.eventId),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Transaction> transactionList = snapshot.data;
            return Scaffold(
              appBar: CustomAppBar(title: "Event Details", backButton: true),
              body: Body(
                event: event,
                transactionList: transactionList,
              ),
              bottomNavigationBar: CustomBottomNavigationBar(),
              floatingActionButton: FloatingActionButton(
                heroTag: "addService",
                onPressed: () {
                  Navigator.pushNamed(
                    context, Routes.service,
                    // arguments: {'service': service, 'vendor': vendor}
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: kPrimaryColor,
              ),
            );
          } else {
            return Text("No data available");
          }
        });
  }
}
