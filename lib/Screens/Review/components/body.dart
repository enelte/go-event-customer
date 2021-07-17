import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/star_rating.dart';
import 'package:go_event_customer/components/switch_input.dart';
import 'package:go_event_customer/controllers/transaction_controller.dart';
import 'package:go_event_customer/models/Review.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  Body({Key key, @required this.transaction, @required this.service})
      : super(key: key);

  final Transaction transaction;
  final Service service;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _commentController = TextEditingController();
  num _rating = 5;
  bool _status = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel customer = Provider.of<UserModel>(context, listen: false);
    Transaction transaction = widget.transaction;
    Service service = widget.service;
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            StarRating(
                value: _rating,
                onChanged: (value) {
                  _rating = value;
                  setState(() {
                    print(_rating);
                  });
                }),
            RoundedInputField(
              title: "Write your comment",
              maxLines: 5,
              icon: Icons.description,
              controller: _commentController,
            ),
            SwitchInput(
                title: "Review as Anonymous",
                status: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                trueValue: "Yes",
                falseValue: "No"),
            RoundedButton(
              text: "Upload Review",
              press: () async {
                Review _newReview = new Review(
                    transactionId: transaction.transactionId,
                    customerName: _status ? "Anonymous" : customer.displayName,
                    serviceId: service.serviceId,
                    rating: _rating,
                    comment: _commentController.text.trim());
                reviewAddedToTransaction(
                        context, transaction, service, _newReview)
                    .whenComplete(() => Navigator.pop(context));
              },
            ),
            RoundedButton(
              text: "Review Later",
              press: () async {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
