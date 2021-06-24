import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/size_config.dart';
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
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
      child: Container(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.service_details,
                arguments: {'service': service});
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: Container(
                    decoration: BoxDecoration(color: kPrimaryLightColor),
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
                    Text(
                      service.serviceName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(16)),
                      maxLines: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rp.${service.price}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.w400,
                            color: kPrimaryColor,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star),
                            Text(
                              //"${service.rating}",
                              "4.5",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(10),
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
  }
}
