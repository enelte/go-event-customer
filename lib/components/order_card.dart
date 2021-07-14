import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:provider/provider.dart';
import '../size_config.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key key,
    this.width = 145,
    @required this.order,
  }) : super(key: key);

  final double width;
  final Transaction order;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final database = Provider.of<FirestoreService>(context);
    return StreamBuilder<Service>(
        stream: database.serviceStream(serviceId: order.serviceId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Service service = snapshot.data;
            return StreamBuilder<UserModel>(
                stream: database.vendorDataStream(service.vendorId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserModel vendor = snapshot.data;
                    return Padding(
                      padding:
                          EdgeInsets.only(left: getProportionateScreenWidth(5)),
                      child: SizedBox(
                        width: getProportionateScreenWidth(width),
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.pushNamed(
                                context, Routes.transaction_details,
                                arguments: {
                                  'service': service,
                                  'vendor': vendor,
                                  'transaction': order,
                                })
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kPrimaryColor),
                                      borderRadius: BorderRadius.circular(29),
                                      gradient: kPrimaryGradient,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              getProportionateScreenWidth(4),
                                          horizontal:
                                              getProportionateScreenWidth(10)),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              service.serviceName,
                                              style: TextStyle(
                                                color: kPrimaryLightColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            OrderCardData(
                                              text: order.bookingDate,
                                              icon: Icons.calendar_today,
                                            ),
                                            OrderCardData(
                                              text:
                                                  service.serviceType != "Venue"
                                                      ? order.location
                                                      : service.address,
                                              icon: Icons.location_on_sharp,
                                            ),
                                            OrderCardData(
                                              text:
                                                  TextFormatter.moneyFormatter(
                                                      order.totalPrice),
                                              fontSize: 13,
                                              icon: Icons.monetization_on_sharp,
                                            ),
                                          ]),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getProportionateScreenWidth(10),
                                    top: getProportionateScreenHeight(6)),
                                child: SizedBox(
                                    child: Text(
                                      order.status,
                                      style: TextStyle(color: kPrimaryColor),
                                      maxLines: 2,
                                    ),
                                    height: getProportionateScreenHeight(40)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('No data available');
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return Text("No data available");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class OrderCardData extends StatelessWidget {
  const OrderCardData({
    Key key,
    @required this.icon,
    @required this.text,
    this.fontSize = 11,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
      child: Row(
        children: [
          Icon(icon,
              size: getProportionateScreenWidth(14), color: Colors.white),
          SizedBox(width: 10),
          Container(
            width: 100,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(fontSize),
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
