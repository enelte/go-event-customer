import 'package:flutter/material.dart';

class Transaction {
  final String transactionId,
      customerId,
      serviceId,
      eventId,
      status,
      notes,
      proofOfPayment,
      transactionDate,
      bookingDate;
  final double totalPrice;
  final int quantity;

  Transaction(
      {this.transactionId,
      this.customerId,
      this.serviceId,
      this.eventId,
      this.notes,
      this.proofOfPayment,
      this.transactionDate,
      this.bookingDate,
      this.totalPrice,
      this.quantity,
      this.status});

  factory Transaction.fromMap(Map<String, dynamic> data, String transactionId) {
    if (data == null) {
      return null;
    }

    String customerId = data['customerId'];
    String serviceId = data['serviceId'];
    String bookingDate = data['bookingDate'];
    String eventId = data['eventId'];
    String notes = data['notes'];
    String proofOfPayment = data['proofOfPayment'];
    String transactionDate = data['transactionDate'];
    String status = data['status'];
    double totalPrice = data['totalPrice'];
    int quantity = data['quantity'];

    return Transaction(
        transactionId: transactionId,
        customerId: customerId,
        serviceId: serviceId,
        bookingDate: bookingDate,
        proofOfPayment: proofOfPayment,
        eventId: eventId,
        notes: notes,
        totalPrice: totalPrice,
        transactionDate: transactionDate,
        quantity: quantity,
        status: status);
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'serviceId': serviceId,
      'bookingDate': bookingDate,
      'proofOfPayment': proofOfPayment,
      'eventId': eventId,
      'notes': notes,
      'totalPrice': totalPrice,
      'transactionDate': transactionDate,
      'quantity': quantity,
      'status': status
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
