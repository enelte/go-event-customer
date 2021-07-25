import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Home/components/section_title.dart';
import 'package:go_event_customer/Screens/Services/Service/service_screen.dart';
import 'package:go_event_customer/components/order_card.dart';
import 'package:go_event_customer/components/service_card.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/screens/Transactions/Transaction/transaction_screen.dart';
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
    final userData = Provider.of<UserModel>(context);
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
                  stream: userData.role == "Customer"
                      ? database.servicesStream()
                      : database.vendorServicesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Service> serviceList = snapshot.data;

                      return serviceList.length != 0
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(
                                  serviceList.length > 5
                                      ? 5
                                      : serviceList.length,
                                  (index) {
                                    return Padding(
                                        padding: EdgeInsets.all(3),
                                        child: ServiceCard(
                                          service: serviceList[index],
                                        ));
                                  },
                                ),
                              ],
                            )
                          : Container(
                              height: 100,
                              child: Center(
                                child: Text(userData.role == "Customer"
                                    ? "No Service Available at the moment"
                                    : "You have not created any service yet"),
                              ),
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
                  stream: userData.role == "Customer"
                      ? database.transactionsStream()
                      : database.vendorTransactionsStream(sort: (lhs, rhs) {
                          return sortTransaction(lhs, rhs, "Latest Order");
                        }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Transaction> transactionList = snapshot.data;
                      return transactionList.length != 0
                          ? Row(
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
                            )
                          : Container(
                              height: 100,
                              child: Center(
                                child: Text(userData.role == "Customer"
                                    ? "You have not created any order yet"
                                    : "You do not have any incoming orders"),
                              ),
                            );
                      ;
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
