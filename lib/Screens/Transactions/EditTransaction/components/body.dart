import 'package:go_event_customer/components/choose_booking_time_range.dart';
import 'package:go_event_customer/components/service_card.dart';
import 'package:go_event_customer/components/time_range.dart';
import 'package:go_event_customer/controllers/transaction_controller.dart';
import 'package:go_event_customer/date_picker.dart';
import 'package:go_event_customer/models/Transaction.dart' as tran;
import 'package:go_event_customer/screens/Transactions/CreateTransaction/components/create_choose_event.dart';
import 'package:go_event_customer/screens/Transactions/CreateTransaction/components/order_details.dart';
import 'package:flutter/material.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:go_event_customer/validator.dart';

class Body extends StatefulWidget {
  final tran.Transaction transaction;
  final Service service;
  const Body({Key key, this.service, this.transaction}) : super(key: key);

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
    _notesController.text = widget.transaction.notes;
    _dateController.text = widget.transaction.bookingDate;
    _startTime = widget.transaction.startTime;
    _endTime = widget.transaction.endTime;
    _eventId = widget.transaction.eventId;
    _locationController.text = widget.transaction.location;
    _totalPrice = widget.transaction.totalPrice;
    _quantity = widget.transaction.quantity;
    _quantityController.text = widget.transaction.quantity.toString();
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
    final Service service = widget.service;
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
                      initialRange: TimeRangeResult(
                          TextFormatter.stringToTimeOfDay(_startTime),
                          TextFormatter.stringToTimeOfDay(_endTime)),
                      onRangeCompleted: (range) {
                        setState(() {
                          _startTime = range.start.format(context);
                          _endTime = range.end.format(context);
                          _quantity = range.end.hour - range.start.hour;
                          _totalPrice = _quantity * service.price;
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
                  if (needReConfirmation(
                          widget.transaction,
                          _notesController.text.trim(),
                          _dateController.text.trim(),
                          _locationController.text.trim(),
                          _startTime,
                          _endTime) &&
                      widget.transaction.status == "Waiting for Payment")
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 280,
                      child: Text(
                        "If you proceed, The order will need to be confirmed again by the vendor",
                        style: TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  RoundedButton(
                    text: "Edit Order",
                    press: () {
                      if (_formKey.currentState.validate() &&
                          _startTime != null &&
                          _endTime != null) {
                        if (!_uploading) {
                          loadingSnackBar(
                              context: context, text: "Order Updated");
                          String transactionId =
                              widget.transaction.transactionId;
                          tran.Transaction editTrans = tran.Transaction(
                              transactionId: transactionId,
                              eventId: _eventId,
                              notes: _notesController.text.trim(),
                              transactionDate:
                                  widget.transaction.transactionDate,
                              bookingDate: _dateController.text.trim(),
                              totalPrice: _totalPrice,
                              quantity: _quantity,
                              location: _locationController.text.trim(),
                              startTime: _startTime,
                              endTime: _endTime,
                              status: needReConfirmation(
                                      widget.transaction,
                                      _notesController.text.trim(),
                                      _dateController.text.trim(),
                                      _locationController.text.trim(),
                                      _startTime,
                                      _endTime)
                                  ? "Waiting for Confirmation"
                                  : widget.transaction.status);
                          setTransaction(context, editTrans)
                              .whenComplete(() => Navigator.pop(context));
                          setState(() {
                            print(_uploading);
                            _uploading = true;
                          });
                        }
                      } else {
                        loadingSnackBar(
                            context: context,
                            text: "Incomplete data, please recheck the order",
                            color: Colors.red);
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
