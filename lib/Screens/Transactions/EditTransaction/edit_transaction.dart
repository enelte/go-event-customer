import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'components/body.dart';

class EditTransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    Service service = serviceMap['service'];
    Transaction transaction = serviceMap['transaction'];
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Order",
        backButton: true,
      ),
      body: Body(
        service: service,
        transaction: transaction,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
