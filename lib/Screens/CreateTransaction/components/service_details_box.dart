import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/size_config.dart';

class ServiceDetailsBox extends StatelessWidget {
  const ServiceDetailsBox({
    Key key,
    @required this.service,
    @required this.vendor,
  }) : super(key: key);

  final Service service;
  final UserModel vendor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Service Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: getProportionateScreenWidth(265),
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(29),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.serviceName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                service.serviceType,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              service.category,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    vendor.displayName,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 6),
                  Text(service.price.toStringAsFixed(0) + "/" + service.unit,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
