import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_event_customer/components/choose_booking_time_range.dart';
import 'package:go_event_customer/components/date_picker_field.dart';
import 'package:go_event_customer/controllers/transaction_controller.dart';
import 'package:go_event_customer/models/Transaction.dart' as tran;
import 'package:go_event_customer/screens/CreateTransaction/components/choose_event.dart';
import 'package:go_event_customer/screens/CreateTransaction/components/order_details.dart';
import 'package:go_event_customer/screens/CreateTransaction/components/service_details_box.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final Service service;
  final UserModel vendor;
  const Body({Key key, this.service, this.vendor}) : super(key: key);

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
  String _eventId;
  String _startTime;
  String _endTime;
  num _quantity;
  num _totalPrice;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _totalPrice = 0;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _dateController.dispose();
    _nameController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel customer = Provider.of<UserModel>(context);
    final Service service = widget.service;
    final UserModel vendor = widget.vendor;
    final database = Provider.of<FirestoreService>(context, listen: false);
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
                  ServiceDetailsBox(service: service, vendor: vendor),
                  RoundedInputField(
                    title: "Booking Date",
                    hintText: "Booking Date",
                    icon: Icons.date_range,
                    readOnly: true,
                    controller: _dateController,
                    suffix: DatePickerField(
                      dateController: _dateController,
                      onDatePicked: (dob, dateFormat) {
                        setState(() {
                          _dateController.text = dateFormat.format(dob);
                        });
                      },
                    ),
                  ),
                  ChooseBookingTimeRange(
                      service: service,
                      onRangeCompleted: (range) {
                        setState(() {
                          _startTime = range.start.format(context);
                          _endTime = range.end.format(context);
                          _quantity = range.end.hour - range.start.hour;
                          _totalPrice = _quantity * service.price;
                        });
                      }),
                  RoundedInputField(
                    title: "Location Address",
                    hintText: "Provide clear and complete address",
                    maxLines: 2,
                    icon: Icons.location_city,
                    controller: _locationController,
                  ),
                  RoundedInputField(
                    title: "Notes",
                    hintText: "Notes",
                    maxLines: 4,
                    icon: Icons.notes,
                    controller: _notesController,
                  ),
                  SizedBox(height: 25),
                  Column(
                    children: [
                      CreateEvent(
                        nameController: _nameController,
                        budgetController: _budgetController,
                        dateController: _dateController,
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
                  ),
                  RoundedButton(
                    text: "Make Order",
                    press: () {
                      if (_formKey.currentState.validate()) {
                        if (!_uploading) {
                          loadingSnackBar(context, "Creating Order");
                          String transactionId = FirebaseFirestore.instance
                              .collection('transactions')
                              .doc()
                              .id;
                          tran.Transaction newTrans = tran.Transaction(
                              transactionId: transactionId,
                              customerId: customer.uid,
                              serviceId: service.serviceId,
                              vendorId: service.vendorId,
                              eventId: _eventId,
                              notes: _notesController.text.trim(),
                              transactionDate: DateTime.now().toString(),
                              bookingDate: _dateController.text.trim(),
                              totalPrice: _totalPrice,
                              quantity: _quantity,
                              location: _locationController.text.trim(),
                              startTime: _startTime,
                              endTime: _endTime,
                              status: "Waiting for Confirmation");
                          createTransaction(context, newTrans)
                              .whenComplete(() => Navigator.of(context).pop());
                          setState(() {
                            print(_uploading);
                            _uploading = true;
                          });
                        }
                      }
                    },
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
