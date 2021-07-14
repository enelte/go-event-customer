import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/upload_proof_of_payment.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/ProofOfPayment.dart';
import 'package:go_event_customer/services/image_picker_service.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_event_customer/controllers/transaction_controller.dart';

class Body extends StatefulWidget {
  Body({Key key, @required this.proofOfPayment, @required this.transactionId})
      : super(key: key);

  final ProofOfPayment proofOfPayment;
  final String transactionId;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _customerRemarksController = TextEditingController();
  final _vendorRemarksController = TextEditingController();
  File imageFile;
  String imageURL;
  @override
  void initState() {
    super.initState();
    if (widget.proofOfPayment != null) {
      imageURL = widget.proofOfPayment.proofOfPaymentPicture;
      _customerRemarksController.text = widget.proofOfPayment.customerRemarks;
      _vendorRemarksController.text = widget.proofOfPayment.vendorRemarks;
    }
  }

  @override
  void dispose() {
    _customerRemarksController.dispose();
    _vendorRemarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProofOfPayment proofOfPayment = widget.proofOfPayment;
    String transactionId = widget.transactionId;
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Upload Proof Of Payment",
                      style: TextStyle(color: kPrimaryColor, fontSize: 16),
                    ),
                  ),
                  UploadProofOfPayment(
                    imageFile: imageFile,
                    imageURL: imageURL,
                    resetImage: () async {
                      imageFile = null;
                      setState(() {});
                    },
                    pickImage: () async {
                      File imagePicked = await chooseImage();
                      if (imagePicked != null) imageFile = imagePicked;
                      setState(() {});
                    },
                  ),
                  RoundedInputField(
                    title: "Customer Remarks",
                    icon: Icons.description,
                    maxLines: 4,
                    controller: _customerRemarksController,
                  ),
                  if (proofOfPayment != null)
                    RoundedInputField(
                      title: "Vendor Remarks",
                      icon: Icons.description,
                      maxLines: 4,
                      readOnly: true,
                    ),
                  if (proofOfPayment == null)
                    Container(
                      width: 280,
                      child: Text(
                        "Disclaimer : \n 1. Please verify the payment proof and remarks before uploading. \n  2. After uploading for the first time, order cannot be cancelled or edited anymore.",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  RoundedButton(
                    text: "Upload Payment",
                    press: () async {
                      if (imageFile != null || imageURL != null) {
                        loadingSnackBar(
                            context, "Uploading Proof of Payment...");
                        ProofOfPayment newPayment = ProofOfPayment(
                            proofOfPaymentId: proofOfPayment != null
                                ? proofOfPayment.proofOfPaymentId
                                : null,
                            transactionId: transactionId,
                            submittedDate:
                                TextFormatter.dateTimeFormatter(DateTime.now()),
                            customerRemarks:
                                _customerRemarksController.text.trim());
                        setProofOfPayment(context, newPayment, imageFile)
                            .whenComplete(() => Navigator.pop(context));
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Future<File> chooseImage() async {
    final imagePicker = Provider.of<ImagePickerService>(context, listen: false);
    File imagePicked = await imagePicker.pickImage(source: ImageSource.gallery);
    return imagePicked;
  }
}
