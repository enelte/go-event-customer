class ProofOfPayment {
  String proofOfPaymentId,
      transactionId,
      proofOfPaymentPicture,
      submittedDate,
      customerRemarks,
      vendorRemarks;

  ProofOfPayment({
    this.proofOfPaymentId,
    this.transactionId,
    this.proofOfPaymentPicture,
    this.submittedDate,
    this.customerRemarks,
    this.vendorRemarks,
  });

  factory ProofOfPayment.fromMap(
      Map<String, dynamic> data, String proofOfPaymentId) {
    if (data == null) {
      return null;
    }
    String transactionId = data['transactionId'];
    String proofOfPaymentPicture = data['proofOfPaymentPicture'];
    String submittedDate = data['submittedDate'];
    String customerRemarks = data['customerRemarks'];
    String vendorRemarks = data['vendorRemarks'];

    return ProofOfPayment(
      proofOfPaymentId: proofOfPaymentId,
      transactionId: transactionId,
      proofOfPaymentPicture: proofOfPaymentPicture,
      submittedDate: submittedDate,
      customerRemarks: customerRemarks,
      vendorRemarks: vendorRemarks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "transactionId": transactionId,
      "proofOfPaymentPicture": proofOfPaymentPicture,
      "submittedDate": submittedDate,
      "customerRemarks": customerRemarks,
      "vendorRemarks": vendorRemarks,
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
