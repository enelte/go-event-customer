class FirestorePath {
  static String userData(String uid) => 'users/$uid';
  static String service(String serviceId) => 'services/$serviceId';
  static String services() => 'services';
  static String review(String serviceId, String reviewId) =>
      'services/$serviceId/reviews/$reviewId';
  static String reviews(String serviceId) => 'services/$serviceId/reviews';
  static String serviceTypes() => 'serviceType';
  static String transaction(String transactionId) =>
      'transactions/$transactionId';
  static String transactions() => 'transactions';
  static String event(String uid, String eventId) =>
      'users/$uid/events/$eventId';
  static String events(String uid) => 'users/$uid/events';
  static String sponsor(String sponsorId) => 'sponsors/$sponsorId';
  static String sponsors() => 'sponsors';
}
