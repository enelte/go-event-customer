class Review {
  String reviewId, customerName, serviceId, transactionId, comment;
  num rating;

  Review({
    this.reviewId,
    this.customerName,
    this.serviceId,
    this.transactionId,
    this.comment,
    this.rating,
  });

  factory Review.fromMap(Map<String, dynamic> data, String reviewId) {
    if (data == null) {
      return null;
    }
    String customerName = data['customerName'];
    String serviceId = data['serviceId'];
    String transactionId = data['transactionId'];
    String comment = data['comment'];
    num rating = data['rating'];

    return Review(
        reviewId: reviewId,
        customerName: customerName,
        serviceId: serviceId,
        transactionId: transactionId,
        comment: comment,
        rating: rating);
  }

  Map<String, dynamic> toMap() {
    return {
      "customerName": customerName,
      "serviceId": serviceId,
      "transactionId": transactionId,
      "comment": comment,
      "rating": rating
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
