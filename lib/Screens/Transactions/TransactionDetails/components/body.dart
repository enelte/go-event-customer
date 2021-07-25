import 'dart:developer';

import 'package:go_event_customer/components/loading_snackbar.dart';
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
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  final Service service;
  final UserModel user;
  final Transaction transaction;
  const Body({Key key, this.service, this.user, this.transaction})
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
    final UserModel user = widget.user;
    final loggedUser = Provider.of<UserModel>(context);
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
                        if (service != null)
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
                            width: getProportionateScreenWidth(300),
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
                                  if (transaction.transactionType != "Planned")
                                    RoundedInputField(
                                      icon: Icons.calendar_today,
                                      fillColor: Colors.white,
                                      readOnly: true,
                                      title: "Booked On : ",
                                      controller: new TextEditingController
                                              .fromValue(
                                          TextEditingValue(
                                              text: TextFormatter
                                                  .dateTimeFormatter(
                                                      DateTime.parse(transaction
                                                          .transactionDate)))),
                                    ),
                                  RoundedInputField(
                                    icon: Icons.monetization_on_sharp,
                                    fillColor: Colors.white,
                                    readOnly: true,
                                    title: "Price Details : ",
                                    controller: new TextEditingController
                                            .fromValue(
                                        TextEditingValue(
                                            text: TextFormatter.moneyFormatter(
                                                transaction.totalPrice))),
                                  ),
                                  RoundedInputField(
                                    icon: Icons.person,
                                    fillColor: Colors.white,
                                    readOnly: true,
                                    title: user.role == "Customer"
                                        ? "Customer"
                                        : "Vendor : ",
                                    controller:
                                        new TextEditingController.fromValue(
                                            TextEditingValue(
                                                text: user.displayName)),
                                  ),
                                  RoundedInputField(
                                    icon: Icons.phone,
                                    fillColor: Colors.white,
                                    readOnly: true,
                                    title: user.role == "Customer"
                                        ? "Customer Contact : "
                                        : "Vendor Contact : ",
                                    controller:
                                        new TextEditingController.fromValue(
                                            TextEditingValue(
                                                text:
                                                    "+62 " + user.phoneNumber)),
                                  ),
                                  Divider(
                                    color: kPrimaryColor,
                                    height: 20,
                                    thickness: 5,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                  RoundedInputField(
                                    icon: Icons.calendar_today,
                                    fillColor: Colors.white,
                                    readOnly: true,
                                    title: "Booking Date",
                                    controller:
                                        new TextEditingController.fromValue(
                                      TextEditingValue(
                                          text: transaction.bookingDate),
                                    ),
                                  ),
                                  Container(
                                    width: getProportionateScreenWidth(270),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RoundedInputField(
                                          width: 165,
                                          icon: Icons.timer,
                                          fillColor: Colors.white,
                                          readOnly: true,
                                          title: "Booking Time",
                                          controller: new TextEditingController
                                              .fromValue(
                                            TextEditingValue(
                                                text: transaction.startTime +
                                                    "-" +
                                                    transaction.endTime),
                                          ),
                                        ),
                                        RoundedInputField(
                                          width: 80,
                                          fillColor: Colors.white,
                                          readOnly: true,
                                          title: "Quantity",
                                          controller: new TextEditingController
                                              .fromValue(
                                            TextEditingValue(
                                              text: (transaction.quantity
                                                          .toString() +
                                                      " ") +
                                                  (service != null
                                                      ? service.unit
                                                              .toUpperCase() +
                                                          "(S)"
                                                      : ""),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RoundedInputField(
                                    icon: Icons.location_city,
                                    fillColor: Colors.white,
                                    readOnly: true,
                                    title: "Booking Address",
                                    maxLines: 4,
                                    controller:
                                        new TextEditingController.fromValue(
                                            TextEditingValue(
                                                text: transaction.location)),
                                  ),
                                  if (loggedUser.role == "Customer" &&
                                      (transaction.status ==
                                              "Waiting for Payment" ||
                                          transaction.status ==
                                              "Waiting for Payment Confirmation"))
                                    PaymentInformation(
                                        transaction: transaction, user: user),
                                  if (transaction.status !=
                                          "Waiting for Confirmation" &&
                                      transaction.status != "Planned")
                                    RoundedButton(
                                      color: kPrimaryLightColor,
                                      textColor: kPrimaryColor,
                                      text: loggedUser.role == "Customer"
                                          ? "Upload/Check Payment"
                                          : "Check Payment",
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
                        //CUSTOMER SUBMIT PLANNED ORDER
                        if (loggedUser.role == "Customer" &&
                            transaction.transactionType == "Planned")
                          service != null
                              ? service.status == true
                                  ? RoundedButton(
                                      color: Colors.deepOrangeAccent,
                                      text: "Make Order",
                                      press: () {
                                        PopUpDialog.confirmationDialog(
                                            context: context,
                                            onPressed: () async {
                                              await submitPlannedTransaction(
                                                      context, transaction)
                                                  .then((value) {
                                                loadingSnackBar(
                                                    context: context,
                                                    text: "Order Submitted");
                                              }).catchError((e) {
                                                loadingSnackBar(
                                                    context: context,
                                                    text:
                                                        "An error occurred, please contact the developer.",
                                                    color: Colors.red);
                                              });
                                            },
                                            title:
                                                "Your order will be forwarded to vendor, proceed?");
                                      },
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        width: 290,
                                        child: Text(
                                          "This service is Inactive, please contact the Vendor or delete this plan",
                                          style: TextStyle(
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    width: 290,
                                    child: Text(
                                      "This service is unavailable, please contact the Vendor or delete this plan",
                                      style: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                        //CUSTOMER EDIT Order
                        if (loggedUser.role == "Customer" && service != null)
                          if (transaction.status ==
                                  "Waiting for Confirmation" ||
                              transaction.status == "Waiting for Payment" ||
                              transaction.transactionType == "Planned")
                            RoundedButton(
                              text: "Edit Order",
                              press: () {
                                Navigator.pushNamed(
                                    context, Routes.edit_transaction,
                                    arguments: {
                                      'service': service,
                                      'transaction': transaction,
                                    });
                              },
                            ),

                        //VENDOR GIVE CONFIRMATION
                        if (loggedUser.role == "Vendor")
                          if (transaction.status ==
                                  "Waiting for Confirmation" ||
                              transaction.status ==
                                  "Waiting for Payment Confirmation")
                            RoundedButton(
                              color: Colors.blueAccent,
                              text: transaction.status ==
                                      "Waiting for Confirmation"
                                  ? "Confirm Order"
                                  : "Confirm Payment",
                              press: () {
                                PopUpDialog.confirmationDialog(
                                    context: context,
                                    onPressed: () async {
                                      transaction.status ==
                                              "Waiting for Confirmation"
                                          ? await confirmTransaction(
                                                  context, transaction)
                                              .then((value) {
                                              loadingSnackBar(
                                                  context: context,
                                                  text: "Order Confirmed");
                                            }).catchError((e) {
                                              loadingSnackBar(
                                                  context: context,
                                                  text:
                                                      "An error occurred, please contact the developer.",
                                                  color: Colors.red);
                                            })
                                          : await confirmPayment(
                                                  context, transaction)
                                              .then((value) {
                                              loadingSnackBar(
                                                  context: context,
                                                  text: "Payment Confirmed");
                                            }).catchError((e) {
                                              loadingSnackBar(
                                                  context: context,
                                                  text:
                                                      "An error occurred, please contact the developer.",
                                                  color: Colors.red);
                                            });
                                    },
                                    title: transaction.status ==
                                            "Waiting for Confirmation"
                                        ? "Confirm Order?"
                                        : "Confirm Payment?");
                              },
                            ),

                        //CANCEL BUTTON
                        if ((transaction.status == "Waiting for Confirmation" ||
                                transaction.status == "Waiting for Payment" ||
                                transaction.status == "Planned") &&
                            loggedUser.role == "Customer")
                          RoundedButton(
                            color: Colors.redAccent,
                            text: transaction.status == "Planned"
                                ? "Delete Planned Order"
                                : "Cancel Order",
                            press: () {
                              PopUpDialog.confirmationDialog(
                                context: context,
                                onPressed: () async {
                                  transaction.status == "Planned"
                                      ? await deleteTransaction(
                                              context, transaction)
                                          .then((value) {
                                          loadingSnackBar(
                                              context: context,
                                              text: "Planned Order Deleted");
                                          Navigator.of(context).pop();
                                        }).catchError((e) {
                                          loadingSnackBar(
                                              context: context,
                                              text:
                                                  "An error occurred, please contact the developer.",
                                              color: Colors.red);
                                        })
                                      : await cancelTransaction(
                                              context, transaction)
                                          .then((value) {
                                          loadingSnackBar(
                                              context: context,
                                              text: "Order Cancelled");
                                        }).catchError((e) {
                                          loadingSnackBar(
                                              context: context,
                                              text:
                                                  "An error occurred, please contact the developer.",
                                              color: Colors.red);
                                        });
                                },
                                title: transaction.status == "Planned"
                                    ? "Delete Planned Order?"
                                    : "Cancel Order?",
                              );
                            },
                          ),
                        //REJECT BUTTON
                        if ((transaction.status == "Waiting for Confirmation" ||
                                transaction.status == "Waiting for Payment" ||
                                transaction.status ==
                                    "Waiting for Payment Confirmation") &&
                            loggedUser.role == "Vendor")
                          RoundedButton(
                            color: Colors.redAccent,
                            text: "Reject Order",
                            press: () {
                              PopUpDialog.confirmationDialog(
                                  context: context,
                                  onPressed: () async {
                                    transaction.status ==
                                            "Waiting for Payment Confirmation"
                                        ? await rejectOrderOnPaymentUploaded(
                                                context, transaction)
                                            .then((value) {
                                            loadingSnackBar(
                                                context: context,
                                                text:
                                                    "Order rejection is waiting for admin confirmation");
                                          }).catchError((e) {
                                            loadingSnackBar(
                                                context: context,
                                                text:
                                                    "An error occurred, please contact the developer.",
                                                color: Colors.red);
                                          })
                                        : await rejectTransaction(
                                                context, transaction)
                                            .then((value) {
                                            loadingSnackBar(
                                                context: context,
                                                text: "Order Rejected");
                                          }).catchError((e) {
                                            loadingSnackBar(
                                                context: context,
                                                text:
                                                    "An error occurred, please contact the developer.",
                                                color: Colors.red);
                                          });
                                  },
                                  title: transaction.status ==
                                          "Waiting for Payment Confirmation"
                                      ? "Rejecting order with payment proof submitted needs admin consent proceed?"
                                      : "Reject the Order?");
                            },
                          ),
                        //CUSTOMER FINISH BOOKING
                        if (loggedUser.role == "Customer" && service != null)
                          if (transaction.status == "In Progress")
                            RoundedButton(
                                color: Colors.blueAccent,
                                text: "Finish Order",
                                press: () {
                                  PopUpDialog.confirmationDialog(
                                    context: context,
                                    onPressed: () async {
                                      await finishTransaction(
                                              context, transaction, service)
                                          .then((value) {
                                        loadingSnackBar(
                                            context: context,
                                            text: "Order Finished");
                                        Navigator.pushNamed(
                                            context, Routes.review, arguments: {
                                          "transaction": transaction,
                                          "service": service
                                        });
                                      }).catchError((e) {
                                        loadingSnackBar(
                                            context: context,
                                            text:
                                                "An error occurred, please contact the developer.",
                                            color: Colors.red);
                                      });
                                    },
                                    title: "Finish Order?",
                                  );
                                }),

                        //CUSTOMER GIVE REVIEW
                        if (loggedUser.role == "Customer" && service != null)
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
                        //CHAT CUSTOMER / VENDOR
                        RoundedButton(
                          color: Colors.green,
                          text: loggedUser.role == "Customer"
                              ? "Chat Vendor"
                              : "Chat Customer",
                          press: () {
                            launchWhatsapp(
                                number: "+62" + user.phoneNumber,
                                message: transaction.status != "On Going"
                                    ? ""
                                    : "Hi, I want to ask about this booking with booking code: " +
                                        transaction.transactionId);
                          },
                        ),
                        //CHAT CUSTOMER / VENDOR
                        RoundedButton(
                          color: Colors.black54,
                          text: "Chat Admin",
                          press: () {
                            launchWhatsapp(
                                number: "+628114001507",
                                message:
                                    "Hi admin, I need help with my order with booking code: " +
                                        transaction.transactionId);
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

class PaymentInformation extends StatelessWidget {
  const PaymentInformation({
    Key key,
    @required this.transaction,
    @required this.user,
  }) : super(key: key);

  final Transaction transaction;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Transfer to the following bank/e-money account",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: getProportionateScreenWidth(270),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedInputField(
                width: 80,
                fillColor: Colors.white,
                readOnly: true,
                title: "Bank Name",
                controller: new TextEditingController.fromValue(
                  TextEditingValue(text: user.bankName),
                ),
              ),
              RoundedInputField(
                width: 165,
                fillColor: Colors.white,
                readOnly: true,
                title: "Bank Number",
                controller: new TextEditingController.fromValue(
                  TextEditingValue(text: user.bankAccountNumber),
                ),
              ),
            ],
          ),
        ),
        RoundedInputField(
          icon: Icons.person,
          fillColor: Colors.white,
          readOnly: true,
          title: "Name on Account",
          controller: new TextEditingController.fromValue(
            TextEditingValue(text: user.bankAccountName),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "After you are done, please upload the payment proof below",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
