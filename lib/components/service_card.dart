import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key key,
    this.width = 140,
    @required this.service,
  }) : super(key: key);

  final double width;
  final Service service;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    return StreamBuilder<UserModel>(
        stream: database.vendorDataStream(service.vendorId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel vendor = snapshot.data;
            return Padding(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
              child: Container(
                width: getProportionateScreenWidth(width),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.service_details,
                        arguments: {'service': service, 'vendor': vendor});
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: AspectRatio(
                          aspectRatio: 1.1,
                          child: Container(
                            decoration:
                                BoxDecoration(color: kPrimaryLightColor),
                            child: service.images.isEmpty
                                ? Container()
                                : Hero(
                                    tag: service.serviceId,
                                    child: Image.network(
                                      service.images[0],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Text(
                                service.serviceName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: getProportionateScreenWidth(15)),
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Rp.${service.price}/",
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(15),
                                      fontWeight: FontWeight.w800,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  Text(service.unit,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(12),
                                        fontWeight: FontWeight.w400,
                                        color: kPrimaryColor,
                                      ))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    Text(
                                      vendor.city,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star),
                                    Text(
                                      //"${service.rating}",
                                      "4.5",
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
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
