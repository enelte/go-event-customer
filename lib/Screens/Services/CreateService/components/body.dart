import 'dart:io';
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
import 'package:go_event_customer/services/auth_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:go_event_customer/validator.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final ServiceType serviceType;
  const Body({Key key, this.serviceType}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _maxOrderController = TextEditingController();
  final _areaController = TextEditingController();
  final _capacityController = TextEditingController();
  String _category;
  bool _status = true;
  List<File> _imageList = [];
  num _minOrder;
  num _maxOrder;
  String _startTime;
  String _endTime;
  bool readOnly;

  @override
  void initState() {
    super.initState();
    _minOrder = 0;
    _maxOrder = 0;
    _startTime = "8:00";
    _endTime = "17:00";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _minOrderController.dispose();
    _maxOrderController.dispose();
    _areaController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ServiceType _type = widget.serviceType;
    final user = Provider.of<UserModel>(context);
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 25),
                  RoundedInputField(
                    title: _type.name + " Name",
                    hintText: "Service Name",
                    icon: Icons.room_service,
                    controller: _nameController,
                    validator: Validator.displayNameValidator,
                  ),
                  RoundedInputField(
                    title: "Description",
                    hintText: "Description",
                    icon: Icons.description,
                    maxLines: 4,
                    controller: _descriptionController,
                    validator: Validator.noValidator,
                  ),
                  DropDownInputField(
                    icon: Icons.star,
                    title: _type.name + " Type",
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
                  RoundedInputField(
                    title: "Price (IDR)",
                    hintText: "Price",
                    icon: Icons.monetization_on,
                    suffixText: "IDR/" + _type.unit,
                    controller: _priceController,
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
                          suffixText: _type.unit,
                          controller: _minOrderController,
                          digitInput: true,
                          validator: Validator.defaultValidator,
                          onChanged: (value) {
                            if (value != "")
                              setState(() {
                                _minOrder = _type.name != "Catering"
                                    ? Validator.hourValidator(
                                        _minOrderController)
                                    : num.parse(
                                        _minOrderController.text.trim());
                              });
                          },
                        ),
                        RoundedInputField(
                          width: 120,
                          title: "Max Order",
                          hintText: "Max Order",
                          iconText: "MAX",
                          suffixText: _type.unit,
                          controller: _maxOrderController,
                          digitInput: true,
                          validator: Validator.defaultValidator,
                          onChanged: (value) {
                            if (value != "")
                              setState(() {
                                _maxOrder = _type.name != "Catering"
                                    ? Validator.hourValidator(
                                        _maxOrderController)
                                    : num.parse(
                                        _maxOrderController.text.trim());
                              });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45, vertical: 10),
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
                        print(_startTime);
                      }),
                    ),
                  ),
                  if (_type.name == "Venue")
                    Column(
                      children: [
                        RoundedInputField(
                          title: "Address",
                          hintText: "Address",
                          icon: Icons.home,
                          controller: _addressController,
                          validator: Validator.addressValidator,
                        ),
                        RoundedInputField(
                            title: "City",
                            hintText: "City",
                            icon: Icons.location_city,
                            controller: _cityController,
                            validator: Validator.cityValidator,
                            onChanged: (value) {
                              if (value != "")
                                _cityController.text = value.toUpperCase();
                              _cityController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: _cityController.text.length));
                            }),
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
                  SwitchInput(
                    status: _status,
                    title: "Status",
                    trueValue: "Active",
                    falseValue: "Inactive",
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 12, bottom: 5),
                          child: Text(
                            "Image Gallery",
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 16),
                          ),
                        ),
                        GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _imageList.length + 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Container(
                                      child: IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        color: Colors.white,
                                        onPressed: () async {
                                          File imagePicked =
                                              await chooseServiceImage(context);
                                          setState(() {
                                            if (imagePicked != null)
                                              _imageList.add(imagePicked);
                                          });
                                        },
                                      ),
                                      decoration: BoxDecoration(
                                          gradient: kPrimaryGradient),
                                      margin: EdgeInsets.all(4),
                                    )
                                  : Stack(
                                      fit: StackFit.expand,
                                      clipBehavior: Clip.none,
                                      children: [
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: FileImage(
                                                    _imageList[index - 1]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: SizedBox(
                                              height: 46,
                                              width: 46,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color(0xFFF5F6F9)),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _imageList
                                                        .removeAt(index - 1);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]);
                            }),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  RoundedButton(
                      text: "Create Service",
                      press: () {
                        PopUpDialog.confirmationDialog(
                            context: context,
                            onPressed: () async {
                              String errorMessage = "";
                              if (_minOrder > _maxOrder) {
                                errorMessage =
                                    "Min Order cannot be larger than Max Order";
                              } else if (_type.name != "Catering") {
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
                                  vendorId: Provider.of<FirebaseAuthService>(
                                          context,
                                          listen: false)
                                      .getCurrentUser()
                                      .uid,
                                  city: user.city,
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
                                  serviceType: _type.name,
                                  category: _category,
                                  unit: _type.unit,
                                  address: user.address,
                                );
                                if (_type.name == "Venue") {
                                  service.city = _cityController.text.trim();
                                  service.address =
                                      _addressController.text.trim();
                                  service.capacity = num.parse(
                                      _capacityController.text.trim());
                                  service.area =
                                      num.parse(_areaController.text.trim());
                                }
                                await setService(
                                        context: context,
                                        service: service,
                                        imageList: _imageList)
                                    .then((value) {
                                  loadingSnackBar(
                                      context: context,
                                      text: "Service Created");
                                  Navigator.of(context).pop();
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
                            title: "Create Service?");
                      }),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
