class Event {
  final String eventId, customerId, eventName, eventDate;
  final num eventBudget;

  Event({
    this.eventId,
    this.customerId,
    this.eventName,
    this.eventDate,
    this.eventBudget,
  });

  factory Event.fromMap(Map<String, dynamic> data, String eventId) {
    if (data == null) {
      return null;
    }
    String customerId = data['customerId'];
    String eventName = data['eventName'];
    String eventDate = data['eventDate'];
    num eventBudget = data['eventBudget'];

    return Event(
      eventId: eventId,
      customerId: customerId,
      eventName: eventName,
      eventDate: eventDate,
      eventBudget: eventBudget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "customerId": customerId,
      "eventName": eventName,
      "eventDate": eventDate,
      "eventBudget": eventBudget,
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
