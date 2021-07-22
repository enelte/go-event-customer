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
    this.width = 155,
    @required this.order,
  }) : super(key: key);

  final double width;
  final Transaction order;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final userData = Provider.of<UserModel>(context);
    final database = Provider.of<FirestoreService>(context);
    return StreamBuilder<Service>(
        stream: database.serviceStream(serviceId: order.serviceId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Service service = snapshot.data;
            return StreamBuilder<UserModel>(
                stream: userData.role == "Customer"
                    ? database.specificUserDataStream(order.vendorId)
                    : database.specificUserDataStream(order.customerId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data;
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
                                  'user': user,
                                  'transaction': order,
                                })
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 0.88,
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: order.transactionType ==
                                                "On Going"
                                            ? kPrimaryColor
                                            : order.transactionType ==
                                                    "Cancelled"
                                                ? Colors.pink
                                                : order.transactionType ==
                                                        "Planned"
                                                    ? Colors.deepOrangeAccent
                                                    : Colors.green,
                                      ),
                                      borderRadius: BorderRadius.circular(29),
                                      gradient: order.transactionType ==
                                              "On Going"
                                          ? kPrimaryGradient
                                          : order.transactionType == "Cancelled"
                                              ? kRedGradient
                                              : order.transactionType ==
                                                      "Planned"
                                                  ? kYellowGradient
                                                  : kGreenGradient,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              getProportionateScreenWidth(10),
                                          horizontal:
                                              getProportionateScreenWidth(10)),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage:
                                                      service.images.isEmpty
                                                          ? avatarImage
                                                          : NetworkImage(
                                                              service.images[0],
                                                            ),
                                                ),
                                                Container(
                                                  width: 90,
                                                  child: Text(
                                                    order.serviceName,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              14),
                                                    ),
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            OrderCardData(
                                              text: user.displayName,
                                              icon: Icons.person,
                                            ),
                                            OrderCardData(
                                              text: order.bookingDate,
                                              icon: Icons.calendar_today,
                                            ),
                                            OrderCardData(
                                              text: order.location,
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
                                      style: TextStyle(
                                        color: order.transactionType ==
                                                "On Going"
                                            ? kPrimaryColor
                                            : order.transactionType ==
                                                    "Cancelled"
                                                ? Colors.pink
                                                : order.transactionType ==
                                                        "Planned"
                                                    ? Colors.deepOrangeAccent
                                                    : Colors.green,
                                      ),
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
    this.fontSize = 10,
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
                  fontWeight: FontWeight.w400),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
