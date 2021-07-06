class Transaction {
  final String transactionId,
      customerId,
      serviceId,
      vendorId,
      eventId,
      status,
      notes,
      transactionDate,
      bookingDate,
      location,
      startTime,
      endTime;
  final num totalPrice, quantity;
  final List proofOfPayment;

  Transaction({
    this.transactionId,
    this.customerId,
    this.serviceId,
    this.vendorId,
    this.eventId,
    this.notes,
    this.proofOfPayment,
    this.transactionDate,
    this.bookingDate,
    this.totalPrice,
    this.quantity,
    this.status,
    this.location,
    this.startTime,
    this.endTime,
  });

  factory Transaction.fromMap(Map<String, dynamic> data, String transactionId) {
    if (data == null) {
      return null;
    }

    String customerId = data['customerId'];
    String serviceId = data['serviceId'];
    String vendorId = data['vendorId'];
    String bookingDate = data['bookingDate'];
    String eventId = data['eventId'];
    String location = data['location'];
    String startTime = data['startTime'];
    String endTime = data['endTime'];
    String notes = data['notes'];
    List proofOfPayment = data['proofOfPayment'];
    String transactionDate = data['transactionDate'];
    String status = data['status'];
    num totalPrice = data['totalPrice'];
    num quantity = data['quantity'];

    return Transaction(
        transactionId: transactionId,
        customerId: customerId,
        serviceId: serviceId,
        vendorId: vendorId,
        bookingDate: bookingDate,
        proofOfPayment: proofOfPayment,
        eventId: eventId,
        notes: notes,
        totalPrice: totalPrice,
        transactionDate: transactionDate,
        quantity: quantity,
        status: status,
        location: location,
        startTime: startTime,
        endTime: endTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'serviceId': serviceId,
      'vendorId': vendorId,
      'bookingDate': bookingDate,
      'proofOfPayment': proofOfPayment,
      'eventId': eventId,
      'notes': notes,
      'totalPrice': totalPrice,
      'transactionDate': transactionDate,
      'quantity': quantity,
      'status': status,
      'location': location,
      'startTime': startTime,
      'endTime': endTime,
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
