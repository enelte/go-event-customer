class Event {
  String eventId, customerId, eventName;
  num eventBudget;

  Event({
    this.eventId,
    this.customerId,
    this.eventName,
    this.eventBudget,
  });

  factory Event.fromMap(Map<String, dynamic> data, String eventId) {
    if (data == null) {
      return null;
    }
    String customerId = data['customerId'];
    String eventName = data['eventName'];
    num eventBudget = data['eventBudget'];

    return Event(
      eventId: eventId,
      customerId: customerId,
      eventName: eventName,
      eventBudget: eventBudget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "customerId": customerId,
      "eventName": eventName,
      "eventBudget": eventBudget,
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
