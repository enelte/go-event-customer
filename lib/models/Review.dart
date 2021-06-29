class Review {
  final String reviewId, customerId, serviceId, comment;
  final double rating;

  Review({
    this.reviewId,
    this.customerId,
    this.serviceId,
    this.comment,
    this.rating,
  });

  factory Review.fromMap(Map<String, dynamic> data, String reviewId) {
    if (data == null) {
      return null;
    }
    String customerId = data['customerId'];
    String serviceId = data['serviceId'];
    String comment = data['comment'];
    double rating = data['rating'];

    return Review(
        reviewId: reviewId,
        customerId: customerId,
        serviceId: serviceId,
        comment: comment,
        rating: rating);
  }

  Map<String, dynamic> toMap() {
    return {
      "customerId": customerId,
      "serviceId": serviceId,
      "comment": comment,
      "rating": rating
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
