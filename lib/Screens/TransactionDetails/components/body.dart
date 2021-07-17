import 'package:go_event_customer/components/service_card.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/controllers/transaction_controller.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  final Service service;
  final UserModel vendor;
  final Transaction transaction;
  const Body({Key key, this.service, this.vendor, this.transaction})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void launchWhatsapp(
      {@required String number, @required String message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("Can't open Whatsapp");
    print(number);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Service service = widget.service;
    final UserModel vendor = widget.vendor;
    final database = Provider.of<FirestoreService>(context);
    return StreamBuilder<Transaction>(
        stream: database.transactionStream(widget.transaction),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Transaction transaction = snapshot.data;
            _notesController.text = transaction.notes;
            return MainBackground(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 25),
                        ServiceCard(
                          service: service,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Booking ID " + transaction.transactionId,
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              //border: Border.all(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 5.0,
                                  offset: Offset(2, 6),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    transaction.status,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text("Booked On : ")),
                                        Text(TextFormatter.dateTimeFormatter(
                                            DateTime.parse(
                                                transaction.transactionDate)))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text("Price Details : ")),
                                        Text(TextFormatter.moneyFormatter(
                                            transaction.totalPrice))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text("Vendor : ")),
                                        Text(vendor.displayName)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text("Vendor Contact : ")),
                                        Text(vendor.phoneNumber)
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: kPrimaryColor,
                                    height: 20,
                                    thickness: 5,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text("Booking Date : ")),
                                        Text(transaction.bookingDate)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text("Booking Time : ")),
                                        Text(transaction.startTime +
                                            " - " +
                                            transaction.endTime)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text("Quantity : ")),
                                        Text(transaction.quantity.toString() +
                                            " " +
                                            service.unit +
                                            "(s)"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text("Booking Address : ")),
                                        Container(
                                          width: 130,
                                          child: Text(
                                            transaction.location,
                                            maxLines: 3,
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (transaction.status !=
                                      "Waiting for Confirmation")
                                    RoundedButton(
                                      color: kPrimaryLightColor,
                                      textColor: kPrimaryColor,
                                      text: "Upload/Check Payment",
                                      press: () {
                                        Navigator.pushNamed(
                                            context, Routes.proof_of_payments,
                                            arguments: {
                                              'transaction': transaction,
                                            });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        RoundedInputField(
                          title: "Notes",
                          hintText: "Notes",
                          maxLines: 4,
                          icon: Icons.notes,
                          controller: _notesController,
                          readOnly: true,
                        ),
                        SizedBox(height: 25),
                        if (transaction.status == "Waiting for Confirmation" ||
                            transaction.status == "Waiting for Payment")
                          RoundedButton(
                            text: "Edit Bookings",
                            press: () {
                              Navigator.pushNamed(
                                  context, Routes.edit_transaction,
                                  arguments: {
                                    'service': service,
                                    'transaction': transaction,
                                  });
                            },
                          ),
                        if (transaction.status == "Waiting for Confirmation" ||
                            transaction.status == "Waiting for Payment")
                          RoundedButton(
                            color: Colors.redAccent,
                            text: "Cancel Bookings",
                            press: () {
                              cancelTransaction(context, transaction);
                            },
                          ),
                        if (transaction.status == "In Progress")
                          RoundedButton(
                            color: Colors.blueAccent,
                            text: "Finish Bookings",
                            press: () async {
                              await finishTransaction(
                                  context, transaction, service);
                              Navigator.pushNamed(context, Routes.review,
                                  arguments: {
                                    "transaction": transaction,
                                    "service": service
                                  });
                            },
                          ),
                        if (transaction.status == "Finished" &&
                            transaction.reviewed != true)
                          RoundedButton(
                            color: Colors.blueAccent,
                            text: "Give Rating and Review",
                            press: () async {
                              Navigator.pushNamed(context, Routes.review,
                                  arguments: {
                                    "transaction": transaction,
                                    "service": service
                                  });
                            },
                          ),
                        RoundedButton(
                          color: Colors.green,
                          text: "Chat Vendor",
                          press: () {
                            launchWhatsapp(
                                number: vendor.phoneNumber
                                    .replaceRange(0, 1, "+62"),
                                message: "Hello");
                          },
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("No data available");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
