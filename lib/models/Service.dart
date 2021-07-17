class Service {
  String serviceId,
      vendorId,
      serviceType,
      serviceName,
      description,
      unit,
      address,
      city,
      category,
      startServiceTime,
      endServiceTime;
  List images;
  num area, capacity, minOrder, maxOrder;
  num price, rating, ordered, review;
  bool status;

  Service(
      {this.serviceId,
      this.vendorId,
      this.images,
      this.serviceType,
      this.serviceName,
      this.description,
      this.price,
      this.minOrder,
      this.maxOrder,
      this.area,
      this.capacity,
      this.status,
      this.rating,
      this.ordered,
      this.review,
      this.category,
      this.unit,
      this.address,
      this.city,
      this.startServiceTime,
      this.endServiceTime});

  factory Service.fromMap(Map<String, dynamic> data, String serviceId) {
    if (data == null) {
      return null;
    }

    String vendorId = data['vendorId'];
    String serviceType = data['serviceType'];
    String serviceName = data['serviceName'];
    String category = data['category'];
    String unit = data['unit'];
    String description = data['description'];
    String address = data['address'];
    String city = data['city'];
    num price = data['price'];
    num minOrder = data['minOrder'];
    num maxOrder = data['maxOrder'];
    num area = data['area'];
    num capacity = data['capacity'];
    bool status = data['status'];
    num rating = data['rating'];
    num ordered = data['ordered'];
    num review = data['review'];
    List images = data['images'];
    String startServiceTime = data['startServiceTime'];
    String endServiceTime = data['endServiceTime'];

    return Service(
        serviceId: serviceId,
        vendorId: vendorId,
        serviceType: serviceType,
        serviceName: serviceName,
        description: description,
        category: category,
        unit: unit,
        price: price,
        address: address,
        city: city,
        minOrder: minOrder,
        maxOrder: maxOrder,
        area: area,
        capacity: capacity,
        status: status,
        rating: rating,
        ordered: ordered,
        review: review,
        images: images,
        startServiceTime: startServiceTime,
        endServiceTime: endServiceTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'serviceType': serviceType,
      'serviceName': serviceName,
      'description': description,
      'category': category,
      'unit': unit,
      'price': price,
      'address': address,
      'city': city,
      'minOrder': minOrder,
      'maxOrder': maxOrder,
      'area': area,
      'capacity': capacity,
      'status': status,
      'rating': rating,
      'ordered': ordered,
      'review': review,
      'images': images,
      'startServiceTime': startServiceTime,
      'endServiceTime': endServiceTime,
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
