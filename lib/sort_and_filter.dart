import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart' as tr;
import 'package:intl/intl.dart';

//Function to search name from search bar
bool searchKeyword(String searchKeyword, String name) {
  String lowerSearchKeyword = searchKeyword.toLowerCase();
  List<String> splittedName = name.toLowerCase().split(" ");
  for (var i = 0; i < splittedName.length; i++) {
    if (splittedName[i].startsWith(lowerSearchKeyword)) return true;
  }
  if (name.toLowerCase().startsWith(lowerSearchKeyword)) return true;
  return false;
}

//Filter Service
Query<Object> filterService(Query query, Service filter) {
  if (filter != null) {
    return query
        .where('serviceType', isEqualTo: filter.serviceName)
        .where('category', isEqualTo: filter.category)
        .where('city', isEqualTo: filter.city);
  } else {
    return query;
  }
}

//Filter Transaction
Query<Object> filterTransaction(Query query, tr.Transaction filter) {
  if (filter != null) {
    return query
        .where('transactionType', isEqualTo: filter.transactionType)
        .where('status', isEqualTo: filter.status)
        .where('reviewed', isEqualTo: filter.reviewed);
  } else {
    return query;
  }
}

//Sort Service
int sortService(Service lhs, Service rhs, String sortType) {
  if (sortType == "Price High to Low") return (rhs.price - lhs.price).round();
  if (sortType == "Price Low to High") return (lhs.price - rhs.price).round();
  if (sortType == "Highest Rating") {
    if (rhs.rating == null) rhs.rating = 0;
    if (lhs.rating == null) lhs.rating = 0;
    return (rhs.rating - lhs.rating).round();
  }
  if (sortType == "Most Ordered") {
    if (rhs.ordered == null) rhs.ordered = 0;
    if (lhs.ordered == null) lhs.ordered = 0;
    return (rhs.ordered - lhs.ordered).round();
  }
  return 0;
}

//Sort Transaction
int sortTransaction(tr.Transaction lhs, tr.Transaction rhs, String sortType) {
  if (sortType == "Total Price High to Low")
    return (rhs.totalPrice - lhs.totalPrice).round();
  if (sortType == "Total Price Low to High")
    return (lhs.totalPrice - rhs.totalPrice).round();
  if (sortType == "Customer Name")
    return (lhs.customerId.compareTo(rhs.customerId)).round();
  if (sortType == "Vendor Name")
    return (lhs.vendorId.compareTo(rhs.vendorId)).round();
  if (sortType == "Latest Bookings")
    return (DateTime.parse(rhs.transactionDate)
            .compareTo(DateTime.parse(lhs.transactionDate)))
        .round();
  if (sortType == "Upcoming Event Date") {
    DateFormat dateFormat = DateFormat("dd MMMM yyyy");
    return (dateFormat
            .parse(lhs.bookingDate)
            .compareTo(dateFormat.parse(rhs.bookingDate)))
        .round();
  }
  return (DateTime.parse(rhs.transactionDate)
          .compareTo(DateTime.parse(lhs.transactionDate)))
      .round();
}
