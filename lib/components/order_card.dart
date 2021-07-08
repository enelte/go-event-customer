import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Transaction.dart';
import '../size_config.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key key,
    this.width = 140,
    this.aspectRetio = 1.92,
    this.order,
  }) : super(key: key);

  final double width, aspectRetio;
  final Transaction order;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () => {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(getProportionateScreenWidth(6)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "eventName",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: getProportionateScreenWidth(16),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getProportionateScreenHeight(5)),
                                child: Row(
                                  children: [
                                    Icon(Icons.person,
                                        size: getProportionateScreenWidth(10)),
                                    Text(
                                      "vendorName",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getProportionateScreenHeight(5)),
                                child: Row(
                                  children: [
                                    Icon(Icons.stay_current_portrait_rounded,
                                        size: getProportionateScreenWidth(10)),
                                    Text(
                                      "transactionID",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getProportionateScreenHeight(5)),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: getProportionateScreenWidth(10)),
                                    Text(
                                      "date",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getProportionateScreenHeight(5)),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_sharp,
                                        size: getProportionateScreenWidth(10)),
                                    Text(
                                      "location",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getProportionateScreenHeight(5)),
                                child: Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        size: getProportionateScreenWidth(10)),
                                    Text(
                                      "price",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(2)),
                child: SizedBox(
                    child: Text(
                      "Status",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w300),
                      maxLines: 2,
                    ),
                    height: getProportionateScreenHeight(30)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
