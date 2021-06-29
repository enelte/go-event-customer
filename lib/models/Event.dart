class Event {
  final String eventId, customerId, eventName, eventDate;
  final double location;

  Event({
    this.eventId,
    this.customerId,
    this.eventName,
    this.eventDate,
    this.location,
  });

  factory Event.fromMap(Map<String, dynamic> data, String eventId) {
    if (data == null) {
      return null;
    }
    String customerId = data['customerId'];
    String eventName = data['eventName'];
    String eventDate = data['eventDate'];
    double location = data['location'];

    return Event(
        eventId: eventId,
        customerId: customerId,
        eventName: eventName,
        eventDate: eventDate,
        location: location);
  }

  Map<String, dynamic> toMap() {
    return {
      "customerId": customerId,
      "eventName": eventName,
      "eventDate": eventDate,
      "location": location
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
