import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/models/ProofOfPayment.dart';
import 'components/body.dart';

class ProofOfPaymentScreen extends StatefulWidget {
  ProofOfPaymentScreen({Key key}) : super(key: key);

  @override
  _ProofOfPaymentScreenState createState() => _ProofOfPaymentScreenState();
}

class _ProofOfPaymentScreenState extends State<ProofOfPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final Map paymentMap = ModalRoute.of(context).settings.arguments;
    ProofOfPayment proofOfPayment = paymentMap['proofOfPayment'];
    String transactionId = paymentMap['transactionId'];
    return Scaffold(
      appBar: CustomAppBar(title: "Proof of Payments", backButton: true),
      body: Body(
        proofOfPayment: proofOfPayment,
        transactionId: transactionId,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
