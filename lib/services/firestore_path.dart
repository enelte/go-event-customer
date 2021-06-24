class FirestorePath {
  static String userData(String uid) => 'users/$uid';
  static String service(String serviceId) => 'services/$serviceId';
  static String services() => 'services';
}
