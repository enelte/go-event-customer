import 'package:flutter/material.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/text_formatter.dart';

class Body extends StatefulWidget {
  final Service service;
  final UserModel vendor;
  const Body({Key key, this.service, this.vendor}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _maxOrderController = TextEditingController();
  final _areaController = TextEditingController();
  final _capacityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.service.description;
    _priceController.text =
        TextFormatter.moneyFormatter(widget.service.price).split(" ")[0];
    _minOrderController.text = widget.service.minOrder.toString();
    _maxOrderController.text = widget.service.maxOrder.toString();
    _areaController.text = widget.service.area.toString();
    _capacityController.text = widget.service.capacity.toString();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _minOrderController.dispose();
    _maxOrderController.dispose();
    _areaController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Service service = widget.service;
    UserModel vendor = widget.vendor;
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.service_gallery,
                    arguments: {'service': service, 'vendor': vendor});
              },
              child: Container(
                width: getProportionateScreenWidth(SizeConfig.screenWidth),
                height: getProportionateScreenHeight(
                    0.35 * SizeConfig.screenHeight),
                child: service.images.isEmpty
                    ? Container()
                    : Image.network(service.images[0], fit: BoxFit.fill),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.service_reviews,
                      arguments: {'service': service});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.payment,
                        ),
                        Text(
                          service.ordered == null
                              ? "0"
                              : service.ordered.toString(),
                          style: TextStyle(fontSize: 25, color: kPrimaryColor),
                        ),
                        Text(
                          "Ordered",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.star),
                        Text(
                          service.rating == 0 || service.rating == null
                              ? "Not rated"
                              : service.rating.toStringAsFixed(2),
                          style: TextStyle(fontSize: 25, color: kPrimaryColor),
                        ),
                        Text(
                          "Rating",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.rate_review),
                        Text(
                          service.review == null
                              ? "0"
                              : service.review.toString(),
                          style: TextStyle(fontSize: 25, color: kPrimaryColor),
                        ),
                        Text(
                          "Reviews",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            RoundedInputField(
              title: "Description",
              hintText: "Description",
              icon: Icons.description,
              maxLines: 4,
              controller: _descriptionController,
              readOnly: true,
            ),
            RoundedInputField(
              title: "Price (IDR)",
              hintText: "Price",
              icon: Icons.money,
              suffixText: "IDR/" + service.unit,
              controller: _priceController,
              readOnly: true,
            ),
            RoundedInputField(
              title: "Min Order",
              hintText: "Min Order",
              icon: Icons.timer_off,
              suffixText: service.unit,
              controller: _minOrderController,
              readOnly: true,
            ),
            RoundedInputField(
              title: "Max Order",
              hintText: "Max Order",
              icon: Icons.timer,
              suffixText: service.unit,
              controller: _maxOrderController,
              readOnly: true,
            ),
            if (service.serviceType == "Venue")
              Column(
                children: [
                  RoundedInputField(
                    title: "Area(M\u00B2)",
                    hintText: "Area",
                    icon: Icons.home,
                    suffixText: "M\u00B2",
                    controller: _areaController,
                    readOnly: true,
                  ),
                  RoundedInputField(
                    title: "Capacity (pax)",
                    hintText: "Capacity",
                    icon: Icons.person,
                    suffixText: "Pax",
                    controller: _capacityController,
                    readOnly: true,
                  ),
                ],
              ),
            SizedBox(height: 25),
            RoundedButton(
              text: "Order Service",
              press: () async {
                Navigator.pushNamed(context, Routes.create_transaction,
                    arguments: {'service': service, 'vendor': vendor});
              },
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
