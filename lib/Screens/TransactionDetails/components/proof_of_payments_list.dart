import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/controllers/transaction_controller.dart';
import 'package:go_event_customer/models/ProofOfPayment.dart';
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
    final database = Provider.of<FirestoreService>(context, listen: false);
    final Map transactionIdMap = ModalRoute.of(context).settings.arguments;
    String transactionId = transactionIdMap['transactionId'];
    return StreamBuilder(
        stream: database.proofOfPaymentsStream(tid: transactionId),
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
                                itemCount: proofOfPaymentList.length + 1,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Container(
                                          child: IconButton(
                                            icon: Icon(Icons.add_a_photo),
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  Routes
                                                      .proof_of_payments_details,
                                                  arguments: {
                                                    "transactionId":
                                                        transactionId,
                                                    "proofOfPayment": null
                                                  });
                                            },
                                          ),
                                          decoration: BoxDecoration(
                                              gradient: kPrimaryGradient),
                                          margin: EdgeInsets.all(4),
                                        )
                                      : Stack(
                                          fit: StackFit.expand,
                                          clipBehavior: Clip.none,
                                          children: [
                                              GestureDetector(
                                                child: Container(
                                                  margin: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          proofOfPaymentList[
                                                                  index - 1]
                                                              .proofOfPaymentPicture),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      Routes
                                                          .proof_of_payments_details,
                                                      arguments: {
                                                        "transactionId":
                                                            transactionId,
                                                        "proofOfPayment":
                                                            proofOfPaymentList[
                                                                index - 1]
                                                      });
                                                },
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: SizedBox(
                                                  height: 35,
                                                  width: 35,
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      loadingSnackBar(context,
                                                          "Deleting Image...");
                                                      deleteProofOfPayment(
                                                          context,
                                                          proofOfPaymentList[
                                                              index - 1]);
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
