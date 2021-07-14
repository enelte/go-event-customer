class Review {
  String reviewId, customerId, serviceId, transactionId, comment;
  num rating;

  Review({
    this.reviewId,
    this.customerId,
    this.serviceId,
    this.transactionId,
    this.comment,
    this.rating,
  });

  factory Review.fromMap(Map<String, dynamic> data, String reviewId) {
    if (data == null) {
      return null;
    }
    String customerId = data['customerId'];
    String serviceId = data['serviceId'];
    String transactionId = data['transactionId'];
    String comment = data['comment'];
    num rating = data['rating'];

    return Review(
        reviewId: reviewId,
        customerId: customerId,
        serviceId: serviceId,
        transactionId: transactionId,
        comment: comment,
        rating: rating);
  }

  Map<String, dynamic> toMap() {
    return {
      "customerId": customerId,
      "serviceId": serviceId,
      "transactionId": transactionId,
      "comment": comment,
      "rating": rating
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
