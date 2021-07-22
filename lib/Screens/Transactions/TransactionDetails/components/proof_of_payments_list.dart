import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/controllers/transaction_controller.dart';
import 'package:go_event_customer/models/ProofOfPayment.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ProofOfPaymentListScreen extends StatefulWidget {
  ProofOfPaymentListScreen({Key key}) : super(key: key);

  @override
  _ProofOfPaymentListScreenState createState() =>
      _ProofOfPaymentListScreenState();
}

class _ProofOfPaymentListScreenState extends State<ProofOfPaymentListScreen> {
  File imageFile;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final database = Provider.of<FirestoreService>(context, listen: false);
    final Map transactionMap = ModalRoute.of(context).settings.arguments;
    Transaction transaction = transactionMap['transaction'];
    return StreamBuilder(
        stream: database.proofOfPaymentsStream(tid: transaction.transactionId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProofOfPayment> proofOfPaymentList = snapshot.data;
            return Scaffold(
              appBar:
                  CustomAppBar(title: "Proof of Payments", backButton: true),
              body: MainBackground(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Proof of Payments List",
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 16),
                              ),
                            ),
                            GridView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: proofOfPaymentList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return Stack(
                                      fit: StackFit.expand,
                                      clipBehavior: Clip.none,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    proofOfPaymentList[index]
                                                        .proofOfPaymentPicture),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            {
                                              Navigator.pushNamed(
                                                  context,
                                                  Routes
                                                      .proof_of_payments_details,
                                                  arguments: {
                                                    "transactionId": transaction
                                                        .transactionId,
                                                    "proofOfPayment":
                                                        proofOfPaymentList[
                                                            index]
                                                  });
                                            }
                                          },
                                        ),
                                        if (transaction.transactionType ==
                                            "On Going")
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.red),
                                                ),
                                                onPressed: () {
                                                  loadingSnackBar(
                                                      context: context,
                                                      text:
                                                          "Proof of Payment deleted");
                                                  deleteProofOfPayment(
                                                      context,
                                                      proofOfPaymentList[
                                                          index]);
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ]);
                                }),
                          ],
                        ),
                      ),
                      if (transaction.transactionType == "On Going" &&
                          user.role == "Customer")
                        RoundedButton(
                          text: "Upload Payment Proof",
                          press: () {
                            Navigator.pushNamed(
                                context, Routes.proof_of_payments_details,
                                arguments: {
                                  "transactionId": transaction.transactionId,
                                  "proofOfPayment": null
                                });
                          },
                        ),
                      SizedBox(height: 25),
                      Container(
                        width: 280,
                        child: Text(
                          "Disclaimer : \n Please upload the correct payment proof, uploading incorrect or fake proof may cause Order cancellation without refund by the vendor",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: CustomBottomNavigationBar(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
