import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'components/body.dart';

class ReviewScreen extends StatefulWidget {
  ReviewScreen({Key key}) : super(key: key);

  @override
  _ReviewScreen createState() => _ReviewScreen();
}

class _ReviewScreen extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final Map reviewMap = ModalRoute.of(context).settings.arguments;
    Transaction transaction = reviewMap['transaction'];
    Service service = reviewMap['service'];
    return Scaffold(
      appBar: CustomAppBar(title: "Review and Rating", backButton: true),
      body: Body(
        transaction: transaction,
        service: service,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
