class Transaction {
  String transactionId,
      customerId,
      serviceId,
      serviceName,
      vendorId,
      eventId,
      status,
      notes,
      transactionDate,
      bookingDate,
      location,
      startTime,
      endTime,
      transactionType;
  num totalPrice, quantity;
  bool reviewed;

  Transaction(
      {this.transactionId,
      this.customerId,
      this.serviceId,
      this.serviceName,
      this.vendorId,
      this.eventId,
      this.notes,
      this.transactionDate,
      this.bookingDate,
      this.totalPrice,
      this.quantity,
      this.status,
      this.location,
      this.startTime,
      this.endTime,
      this.transactionType,
      this.reviewed});

  factory Transaction.fromMap(Map<String, dynamic> data, String transactionId) {
    if (data == null) {
      return null;
    }

    String customerId = data['customerId'];
    String serviceId = data['serviceId'];
    String vendorId = data['vendorId'];
    String serviceName = data['serviceName'];
    String bookingDate = data['bookingDate'];
    String eventId = data['eventId'];
    String location = data['location'];
    String startTime = data['startTime'];
    String endTime = data['endTime'];
    String notes = data['notes'];
    String transactionDate = data['transactionDate'];
    String status = data['status'];
    String transactionType = data['transactionType'];
    num totalPrice = data['totalPrice'];
    num quantity = data['quantity'];
    bool reviewed = data['reviewed'];

    return Transaction(
      transactionId: transactionId,
      customerId: customerId,
      serviceId: serviceId,
      serviceName: serviceName,
      vendorId: vendorId,
      bookingDate: bookingDate,
      eventId: eventId,
      notes: notes,
      totalPrice: totalPrice,
      transactionDate: transactionDate,
      quantity: quantity,
      status: status,
      location: location,
      startTime: startTime,
      endTime: endTime,
      transactionType: transactionType,
      reviewed: reviewed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'vendorId': vendorId,
      'bookingDate': bookingDate,
      'eventId': eventId,
      'notes': notes,
      'totalPrice': totalPrice,
      'transactionDate': transactionDate,
      'quantity': quantity,
      'status': status,
      'location': location,
      'startTime': startTime,
      'endTime': endTime,
      'transactionType': transactionType,
      'reviewed': reviewed
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
