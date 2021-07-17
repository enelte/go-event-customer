import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Home/components/section_title.dart';
import 'package:go_event_customer/Screens/Service/service_screen.dart';
import 'package:go_event_customer/components/order_card.dart';
import 'package:go_event_customer/components/service_card.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/screens/Transaction/transaction_screen.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/sort_and_filter.dart';
import 'package:provider/provider.dart';

class SliderList extends StatelessWidget {
  const SliderList({
    Key key,
    this.title,
    this.type,
  }) : super(key: key);

  final String title, type;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SectionTitle(
              title: title,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (type == "service") return ServiceScreen();
                      return TransactionScreen();
                    },
                  ),
                );
              }),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: type == "service"
              ? StreamBuilder(
                  stream: database.servicesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Service> serviceList = snapshot.data;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(
                            serviceList.length > 5 ? 5 : serviceList.length,
                            (index) {
                              return Padding(
                                  padding: EdgeInsets.all(3),
                                  child: ServiceCard(
                                    service: serviceList[index],
                                  ));
                            },
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text("No data available");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              : StreamBuilder(
                  stream: database.transactionsStream(sort: (lhs, rhs) {
                    return sortTransaction(lhs, rhs, "Latest Booking");
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Transaction> transactionList = snapshot.data;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(
                            transactionList.length > 5
                                ? 5
                                : transactionList.length,
                            (index) {
                              return Padding(
                                  padding: EdgeInsets.all(3),
                                  child: OrderCard(
                                    order: transactionList[index],
                                  ));
                            },
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text("No data available");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
        ),
      ],
    );
  }
}
