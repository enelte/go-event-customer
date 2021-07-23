import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key key,
    this.width = 155,
    @required this.service,
  }) : super(key: key);

  final double width;
  final Service service;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final database = Provider.of<FirestoreService>(context, listen: false);
    return StreamBuilder<UserModel>(
        stream: database.specificUserDataStream(service.vendorId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel vendor = snapshot.data;
            if (user.role == "Customer") {
              return ServiceCardBuilder(
                  width: width, service: service, vendor: vendor);
            } else {
              return StreamBuilder<Object>(
                  stream: database.vendorTransactionsStream(
                      queryBuilder: (query) => query
                          .where("serviceId", isEqualTo: service.serviceId)
                          .where("transactionType", isEqualTo: "On Going")),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Transaction> transactionList = snapshot.data;
                      return ServiceCardBuilder(
                        width: width,
                        service: service,
                        vendor: vendor,
                        transactionList: transactionList,
                      );
                    } else {
                      return Text("No Data Available");
                    }
                  });
            }
          } else if (snapshot.hasError) {
            print(e);
            return Center(
              child: Text("No data available"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class ServiceCardBuilder extends StatelessWidget {
  const ServiceCardBuilder({
    Key key,
    @required this.width,
    @required this.service,
    @required this.vendor,
    this.transactionList,
  }) : super(key: key);

  final double width;
  final Service service;
  final UserModel vendor;
  final List<Transaction> transactionList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
      child: Container(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.service_details, arguments: {
              'service': service,
              'vendor': vendor,
              'transactionList': transactionList
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(color: kPrimaryLightColor),
                        child: service.images.isEmpty
                            ? Container()
                            : Hero(
                                tag: service.serviceId,
                                child: service.images.isEmpty
                                    ? Image.network(avatarImage.url,
                                        fit: BoxFit.fill)
                                    : Image.network(service.images[0],
                                        fit: BoxFit.fill),
                              ),
                      ),
                    ),
                  ),
                  if (service.rating != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                Text(
                                  service.rating.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: getProportionateScreenWidth(11),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text(
                            service.category,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: getProportionateScreenWidth(150),
                      child: Text(
                        service.serviceName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15)),
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        
                        children: [
                          Text(
                            TextFormatter.moneyFormatter(service.price),
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w800,
                              color: kPrimaryColor,
                            ),
                          ),
                          Text("/" + service.unit,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(9),
                                fontWeight: FontWeight.w300,
                                color: kPrimaryColor,
                              ))
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 15,
                        ),
                        Container(
                          width: getProportionateScreenWidth(115),
                          child: Text(
                            service.city,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(11),
                              color: Colors.black,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
