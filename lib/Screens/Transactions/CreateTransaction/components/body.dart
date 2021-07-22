import 'package:go_event_customer/components/choose_booking_time_range.dart';
import 'package:go_event_customer/components/service_card.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/controllers/transaction_controller.dart';
import 'package:go_event_customer/date_picker.dart';
import 'package:go_event_customer/models/ServiceType.dart';
import 'package:go_event_customer/models/Transaction.dart' as tran;
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/screens/Transactions/CreateTransaction/components/create_choose_event.dart';
import 'package:go_event_customer/screens/Transactions/CreateTransaction/components/order_details.dart';
import 'package:flutter/material.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/validator.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final Service service;
  final UserModel vendor;
  const Body({Key key, this.service, this.vendor, ServiceType serviceType})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();
  final _quantityController = TextEditingController();
  String _eventId;
  String _startTime;
  String _endTime;
  num _quantity;
  num _totalPrice;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _quantity = 0;
    _totalPrice = 0;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _dateController.dispose();
    _nameController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel customer = Provider.of<UserModel>(context);
    final Service service = widget.service;
    final UserModel vendor = widget.vendor;
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
                  ServiceCard(service: service),
                  Container(
                    width: 270,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vendor Name :",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(vendor.displayName)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vendor Contact :",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(vendor.phoneNumber)
                          ],
                        ),
                      ],
                    ),
                  ),
                  RoundedInputField(
                    title: "Booking Date",
                    hintText: "Booking Date",
                    icon: Icons.date_range,
                    readOnly: true,
                    controller: _dateController,
                    validator: Validator.dateValidator,
                    onTap: () async {
                      pickDate(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          dateController: _dateController,
                          onDatePicked: (dob, dateFormat) {
                            _dateController.text = dateFormat.format(dob);
                          });
                    },
                  ),
                  ChooseBookingTimeRange(
                      service: service,
                      onRangeCompleted: (range) {
                        setState(() {
                          _startTime = range.start.format(context);
                          _endTime = range.end.format(context);
                          if (service.serviceType != "Catering") {
                            _quantity = range.end.hour - range.start.hour;
                            _totalPrice = _quantity * service.price;
                          }
                        });
                      }),
                  if (_startTime == null && _endTime == null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 65),
                          child: Text(
                            "Please enter time range",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  if (service.serviceType == "Catering")
                    RoundedInputField(
                      title: "Number of Pax",
                      hintText: "min. " +
                          service.minOrder.toString() +
                          " max. " +
                          service.maxOrder.toString(),
                      icon: Icons.fastfood,
                      controller: _quantityController,
                      digitInput: true,
                      validator: Validator.defaultValidator,
                      onFieldSubmitted: (value) {
                        setState(() {
                          _quantity = Validator.quantityValidator(
                              _quantityController,
                              service.minOrder,
                              service.maxOrder);
                          _totalPrice = _quantity * service.price;
                        });
                      },
                    ),
                  if (service.serviceType != "Venue")
                    RoundedInputField(
                      title: "Location Address",
                      hintText: "Provide clear and complete address",
                      maxLines: 2,
                      icon: Icons.location_city,
                      controller: _locationController,
                      validator: Validator.addressValidator,
                    ),
                  RoundedInputField(
                    title: "Notes",
                    hintText: "Notes",
                    maxLines: 4,
                    icon: Icons.notes,
                    controller: _notesController,
                    validator: Validator.noValidator,
                  ),
                  SizedBox(height: 25),
                  Column(
                    children: [
                      ChooseEvent(
                        nameController: _nameController,
                        budgetController: _budgetController,
                        eventId: _eventId,
                        onCreate: () {
                          setState(() {
                            _nameController.text = "";
                            _dateController.text = "";
                            _budgetController.text = "";
                          });
                        },
                        onSelected: (newValue) {
                          setState(() {
                            _eventId = newValue;
                            print(_eventId);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  OrderDetails(
                    dateController: _dateController,
                    startTime: _startTime,
                    endTime: _endTime,
                    totalPrice: _totalPrice,
                    eventId: _eventId,
                    quantity: _quantity.toString() + " " + service.unit + "(s)",
                  ),
                  SizedBox(height: 25),
                  RoundedButton(
                    text: "Make Order",
                    press: () {
                      PopUpDialog.confirmationDialog(
                          context: context,
                          onPressed: () async {
                            if (_formKey.currentState.validate() &&
                                _startTime != null &&
                                _endTime != null) {
                              if (!_uploading) {
                                tran.Transaction newTrans = tran.Transaction(
                                  customerId: customer.uid,
                                  serviceId: service.serviceId,
                                  vendorId: service.vendorId,
                                  serviceName: service.serviceName,
                                  eventId: _eventId,
                                  notes: _notesController.text.trim(),
                                  transactionDate: DateTime.now().toString(),
                                  bookingDate: _dateController.text.trim(),
                                  totalPrice: _totalPrice,
                                  quantity: _quantity,
                                  location: service.serviceType == "Venue"
                                      ? service.address
                                      : _locationController.text.trim(),
                                  startTime: _startTime,
                                  endTime: _endTime,
                                  status: "Waiting for Confirmation",
                                  transactionType: "On Going",
                                  reviewed: false,
                                );
                                await setTransaction(context, newTrans)
                                    .then((value) {
                                  loadingSnackBar(
                                      context: context, text: "Order Created");
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _uploading = true;
                                  });
                                }).catchError((e) {
                                  loadingSnackBar(
                                      context: context,
                                      text: "An Error Ocurred",
                                      color: Colors.red);
                                });
                              }
                            } else {
                              loadingSnackBar(
                                  context: context,
                                  text:
                                      "Incomplete data, please recheck the order",
                                  color: Colors.red);
                            }
                          },
                          title:
                              "Your order will be forwarded to the vendor. Proceed?");
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      width: 290,
                      child: Text(
                        "Choose make order to forward order to vendor immediately",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  RoundedButton(
                    text: "Plan Order",
                    press: () {
                      PopUpDialog.confirmationDialog(
                          context: context,
                          onPressed: () async {
                            if (_formKey.currentState.validate() &&
                                _startTime != null &&
                                _endTime != null) {
                              if (!_uploading) {
                                tran.Transaction newTrans = tran.Transaction(
                                  customerId: customer.uid,
                                  serviceId: service.serviceId,
                                  vendorId: service.vendorId,
                                  serviceName: service.serviceName,
                                  eventId: _eventId,
                                  notes: _notesController.text.trim(),
                                  transactionDate: DateTime.now().toString(),
                                  bookingDate: _dateController.text.trim(),
                                  totalPrice: _totalPrice,
                                  quantity: _quantity,
                                  location: service.serviceType == "Venue"
                                      ? service.address
                                      : _locationController.text.trim(),
                                  startTime: _startTime,
                                  endTime: _endTime,
                                  status: "Planned",
                                  transactionType: "Planned",
                                  reviewed: false,
                                );
                                setTransaction(context, newTrans).then((value) {
                                  loadingSnackBar(
                                      context: context, text: "Order Planned");
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _uploading = true;
                                  });
                                }).catchError((e) {
                                  loadingSnackBar(
                                      context: context,
                                      text: "An Error Ocurred",
                                      color: Colors.red);
                                });
                              }
                            } else {
                              loadingSnackBar(
                                  context: context,
                                  text:
                                      "Incomplete data, please recheck the order",
                                  color: Colors.red);
                            }
                          },
                          title: "Plan the Order?");
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      width: 290,
                      child: Text(
                        "Choose plan order to save the order draft without ordering for planning purpose",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
