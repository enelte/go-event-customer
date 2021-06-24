class Order {
  final String customerName, status, orderNumber, eventName;
  final String date;
  final int id;

  Order({
    this.id,
    this.customerName,
    this.orderNumber,
    this.eventName,
    this.date,
    this.status,
  });
}

List<Order> orders = [
  Order(
      id: 1,
      orderNumber: "INV/20213017",
      customerName: "Nicholas Lingga",
      eventName: "Lingga's Birthday Party",
      date: "17 March 2021",
      status: "Waiting for Confirmation"),
  Order(
      id: 2,
      orderNumber: "INV/20213017",
      customerName: "Nicholas Lingga",
      eventName: "Lingga's Birthday Party",
      date: "17 March 2021",
      status: "Approved"),
  Order(
      id: 3,
      orderNumber: "INV/20213017",
      customerName: "Nicholas Lingga",
      eventName: "Lingga's Birthday Party",
      date: "17 March 2021",
      status: "Approved"),
  Order(
      id: 4,
      orderNumber: "INV/20213017",
      customerName: "Nicholas Lingga",
      eventName: "Lingga's Birthday Party",
      date: "17 March 2021",
      status: "Approved"),
  Order(
      id: 5,
      orderNumber: "INV/20213017",
      customerName: "Nicholas Lingga",
      eventName: "Lingga's Birthday Party",
      date: "17 March 2021",
      status: "Canceled"),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
