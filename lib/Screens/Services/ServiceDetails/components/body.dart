import 'package:flutter/material.dart';
import 'package:go_event_customer/components/dropdown_input_field.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/switch_input.dart';
import 'package:go_event_customer/components/time_range.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/controllers/service_controller.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/ServiceType.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:go_event_customer/validator.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final Service service;
  final UserModel vendor;
  final ServiceType serviceType;
  const Body({Key key, this.service, this.vendor, this.serviceType})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _maxOrderController = TextEditingController();
  final _areaController = TextEditingController();
  final _capacityController = TextEditingController();
  final _startServiceTimeController = TextEditingController();
  final _endServiceTimeController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  String _category;
  num _minOrder;
  num _maxOrder;
  String _startTime;
  String _endTime;
  bool _status;
  bool readOnly;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.service.serviceName;
    _descriptionController.text = widget.service.description;
    _priceController.text =
        TextFormatter.moneyFormatter(widget.service.price).split(" ")[0];
    _minOrderController.text = widget.service.minOrder.toString();
    _maxOrderController.text = widget.service.maxOrder.toString();
    _startServiceTimeController.text = widget.service.startServiceTime;
    _endServiceTimeController.text = widget.service.endServiceTime;
    _areaController.text = widget.service.area.toString();
    _capacityController.text = widget.service.capacity.toString();
    _addressController.text = widget.service.address;
    _cityController.text = widget.service.city;
    _minOrder = widget.service.minOrder;
    _maxOrder = widget.service.maxOrder;
    _startTime = widget.service.startServiceTime;
    _endTime = widget.service.endServiceTime;
    _status = widget.service.status;
    _category = widget.service.category;
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
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ServiceType _type = widget.serviceType;
    Service service = widget.service;
    UserModel vendor = widget.vendor;
    UserModel user = Provider.of<UserModel>(context);
    readOnly = user.role == "Customer" ? true : false;
    return MainBackground(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                      ? Image.network(
                          avatarImage.url,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        )
                      : Image.network(
                          service.images[0],
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.center
                        ),
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
                            style:
                                TextStyle(fontSize: 25, color: kPrimaryColor),
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
                            style:
                                TextStyle(fontSize: 25, color: kPrimaryColor),
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
                            style:
                                TextStyle(fontSize: 25, color: kPrimaryColor),
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
              if (user.role == "Vendor")
                RoundedInputField(
                  title: "Service Name",
                  hintText: "Service Name",
                  icon: Icons.group,
                  controller: _nameController,
                  readOnly: readOnly,
                  validator: Validator.displayNameValidator,
                ),
              RoundedInputField(
                title: "Description",
                hintText: "Description",
                icon: Icons.description,
                maxLines: 4,
                controller: _descriptionController,
                readOnly: readOnly,
                validator: Validator.noValidator,
              ),
              if (user.role == "Vendor")
                DropDownInputField(
                  icon: Icons.star,
                  title: service.serviceType + " Type",
                  value: _category,
                  dropDownItems: _type.category.map((dynamic category) {
                    return new DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Container(
                                  width: 160,
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ),
                          ],
                        ));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() => _category = newValue);
                  },
                ),
              if (user.role == "Customer")
                RoundedInputField(
                    title: "Category",
                    hintText: "Category",
                    icon: Icons.star,
                    controller: new TextEditingController(text: _category),
                    readOnly: readOnly,
                    validator: Validator.noValidator),
              RoundedInputField(
                title: "Price (IDR)",
                hintText: "Price",
                icon: Icons.monetization_on,
                suffixText: "IDR/" + service.unit,
                controller: _priceController,
                readOnly: readOnly,
                validator: Validator.budgetValidator,
                digitInput: true,
                isMoney: true,
              ),
              Container(
                width: getProportionateScreenWidth(270),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedInputField(
                      width: 120,
                      title: "Min Order",
                      hintText: "Min Order",
                      iconText: "MIN",
                      suffixText: service.unit,
                      controller: _minOrderController,
                      readOnly: readOnly,
                      digitInput: true,
                      validator: Validator.defaultValidator,
                      onChanged: (value) {
                        if (value != "")
                          setState(() {
                            _minOrder = service.serviceType != "Catering"
                                ? Validator.hourValidator(_minOrderController)
                                : num.parse(_minOrderController.text.trim());
                          });
                      },
                    ),
                    RoundedInputField(
                      width: 120,
                      title: "Max Order",
                      hintText: "Max Order",
                      iconText: "MAX",
                      suffixText: service.unit,
                      controller: _maxOrderController,
                      readOnly: readOnly,
                      digitInput: true,
                      validator: Validator.defaultValidator,
                      onChanged: (value) {
                        if (value != "")
                          setState(() {
                            _maxOrder = service.serviceType != "Catering"
                                ? Validator.hourValidator(_maxOrderController)
                                : num.parse(_maxOrderController.text.trim());
                          });
                      },
                    ),
                  ],
                ),
              ),
              if (readOnly)
                Container(
                  width: getProportionateScreenWidth(270),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedInputField(
                          width: 120,
                          icon: Icons.timer,
                          iconColor: Colors.green,
                          readOnly: readOnly,
                          title: "Start Time",
                          controller: _startServiceTimeController),
                      RoundedInputField(
                          width: 120,
                          icon: Icons.timer_off,
                          iconColor: Colors.red,
                          readOnly: readOnly,
                          title: "End Time",
                          controller: _endServiceTimeController),
                    ],
                  ),
                ),
              if (!readOnly)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                  child: TimeRange(
                    fromTitle: Text(
                      'Start Service Hour',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    toTitle: Text(
                      'End Service Hour',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    titlePadding: 20,
                    textStyle: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black87),
                    activeTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    borderColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    activeBackgroundColor: kPrimaryColor,
                    firstTime: TimeOfDay(hour: 00, minute: 00),
                    lastTime: TimeOfDay(hour: 23, minute: 59),
                    timeStep: 60,
                    timeBlock: 60,
                    initialRange: TimeRangeResult(
                        TextFormatter.stringToTimeOfDay(_startTime),
                        TextFormatter.stringToTimeOfDay(_endTime)),
                    onRangeCompleted: (range) => setState(() {
                      _startTime = TextFormatter.formatTimeOfDay(range.start);
                      _endTime = TextFormatter.formatTimeOfDay(range.end);
                      print(TextFormatter.stringToTimeOfDay(_endTime).hour -
                          TextFormatter.stringToTimeOfDay(_startTime).hour);
                    }),
                  ),
                ),
              RoundedInputField(
                title: service.serviceType == "Venue"
                    ? "Venue Address"
                    : "Service Address",
                hintText: "Address",
                icon: Icons.home,
                controller: _addressController,
                readOnly: readOnly,
                validator: Validator.addressValidator,
              ),
              RoundedInputField(
                  title: "City",
                  hintText: "City",
                  icon: Icons.location_city,
                  controller: _cityController,
                  readOnly: readOnly,
                  validator: Validator.cityValidator,
                  onChanged: (value) {
                    if (value != "") _cityController.text = value.toUpperCase();
                    _cityController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _cityController.text.length));
                  }),
              if (service.serviceType == "Venue")
                Column(
                  children: [
                    RoundedInputField(
                      title: "Area(M\u00B2)",
                      hintText: "Area",
                      icon: Icons.home,
                      suffixText: "M\u00B2",
                      controller: _areaController,
                      readOnly: readOnly,
                      digitInput: true,
                      validator: Validator.defaultValidator,
                    ),
                    RoundedInputField(
                      title: "Capacity (pax)",
                      hintText: "Capacity",
                      icon: Icons.person,
                      suffixText: "Pax",
                      controller: _capacityController,
                      readOnly: readOnly,
                      digitInput: true,
                      validator: Validator.defaultValidator,
                    ),
                  ],
                ),
              if (user.role == "Vendor")
                SwitchInput(
                    title: "Service Status",
                    status: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    trueValue: "Active",
                    falseValue: "Inactive"),
              SizedBox(height: 25),
              user.role == "Customer"
                  ? RoundedButton(
                      text: "Order Service",
                      press: () async {
                        Navigator.pushNamed(context, Routes.create_transaction,
                            arguments: {'service': service, 'vendor': vendor});
                      },
                    )
                  : RoundedButton(
                      text: "Update Service Data",
                      press: () {
                        PopUpDialog.confirmationDialog(
                            context: context,
                            onPressed: () async {
                              String errorMessage = "";
                              if (_minOrder > _maxOrder) {
                                errorMessage =
                                    "Min Order cannot be larger than Max Order";
                              } else if (service.serviceType != "Catering") {
                                num serviceHoursCount =
                                    TextFormatter.stringToTimeOfDay(_endTime)
                                            .hour -
                                        TextFormatter.stringToTimeOfDay(
                                                _startTime)
                                            .hour;
                                if (_maxOrder > serviceHoursCount)
                                  errorMessage =
                                      "Max Order can't be larger than number of service hours per day : " +
                                          serviceHoursCount.toString() +
                                          " hour(s)";
                              }
                              if (!_formKey.currentState.validate())
                                errorMessage =
                                    "Please complete the service form";
                              if (errorMessage == "") {
                                final service = Service(
                                  serviceId: widget.service.serviceId,
                                  serviceName: _nameController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                  price: num.parse(_priceController.text
                                      .trim()
                                      .replaceAll(".", "")),
                                  startServiceTime: _startTime,
                                  endServiceTime: _endTime,
                                  minOrder: num.parse(
                                      _minOrderController.text.trim()),
                                  maxOrder: num.parse(
                                      _maxOrderController.text.trim()),
                                  status: _status,
                                  city: _cityController.text.trim(),
                                  address: _addressController.text.trim(),
                                  category: _category,
                                );
                                if (widget.service.serviceType == "Venue") {
                                  service.capacity = num.parse(
                                      _capacityController.text.trim());
                                  service.area =
                                      num.parse(_areaController.text.trim());
                                }
                                await setService(
                                        context: context, service: service)
                                    .then((value) {
                                  setState(() {});
                                  loadingSnackBar(
                                      context: context,
                                      text: "Service Updated");
                                }).catchError((e) {
                                  loadingSnackBar(
                                      context: context,
                                      text: "An error occurred, please contact the developer.",
                                      color: Colors.red);
                                });
                              } else {
                                loadingSnackBar(
                                    context: context,
                                    text: errorMessage,
                                    color: Colors.red);
                              }
                            },
                            title: "Update Service Data?");
                      },
                    ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
