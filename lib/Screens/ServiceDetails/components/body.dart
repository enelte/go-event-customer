import 'package:flutter/material.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final Service service;
  final UserModel vendor;
  const Body({Key key, this.service, this.vendor}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _maxOrderController = TextEditingController();
  final _areaController = TextEditingController();
  final _capacityController = TextEditingController();
  bool _status;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.service.serviceName;
    _descriptionController.text = widget.service.description;
    _priceController.text = widget.service.price.toString();
    _minOrderController.text = widget.service.minOrder.toString();
    _maxOrderController.text = widget.service.maxOrder.toString();
    _areaController.text = widget.service.area.toString();
    _capacityController.text = widget.service.capacity.toString();
    _status = widget.service.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            Container(
              width: getProportionateScreenWidth(SizeConfig.screenWidth),
              height:
                  getProportionateScreenHeight(0.35 * SizeConfig.screenHeight),
              child: service.images.isEmpty
                  ? Container()
                  : Image.network(service.images[0], fit: BoxFit.fill),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                service.serviceName,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.payment,
                      ),
                      Text(
                        "126",
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
                        "4.3",
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
                        "88",
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
            RoundedInputField(
              title: "Service Name",
              hintText: "Service Name",
              icon: Icons.room_service,
              controller: _nameController,
            ),
            RoundedInputField(
              title: "Description",
              hintText: "Description",
              icon: Icons.description,
              maxLines: 4,
              controller: _descriptionController,
            ),
            RoundedInputField(
              title: "Price (IDR)",
              hintText: "Price",
              icon: Icons.money,
              suffixText: "IDR/" + service.unit,
              controller: _priceController,
              digitInput: true,
            ),
            RoundedInputField(
              title: "Min Order",
              hintText: "Min Order",
              icon: Icons.timer_off,
              suffixText: service.unit,
              controller: _minOrderController,
              digitInput: true,
            ),
            RoundedInputField(
              title: "Max Order",
              hintText: "Max Order",
              icon: Icons.timer,
              suffixText: service.unit,
              controller: _maxOrderController,
              digitInput: true,
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
                    digitInput: true,
                  ),
                  RoundedInputField(
                    title: "Capacity (pax)",
                    hintText: "Capacity",
                    icon: Icons.person,
                    suffixText: "Pax",
                    controller: _capacityController,
                    digitInput: true,
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Status",
                  style: TextStyle(color: kPrimaryColor, fontSize: 16),
                ),
                Row(
                  children: [
                    Switch(
                      value: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                      activeTrackColor: kPrimaryColor,
                      activeColor: kPrimaryLightColor,
                    ),
                    Text(
                      _status ? "Active" : "Inactive",
                      style: TextStyle(
                          color: _status ? Colors.green : Colors.redAccent),
                    ),
                  ],
                )
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
