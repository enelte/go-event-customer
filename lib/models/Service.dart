class Service {
  final String serviceId,
      vendorId,
      serviceType,
      serviceName,
      description,
      unit,
      address,
      category;
  final List images;
  final num area, capacity, minOrder, maxOrder;
  final num price, rating;
  final bool status;

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
      this.category,
      this.unit,
      this.address});

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
    num price = data['price'];
    num minOrder = data['minOrder'];
    num maxOrder = data['maxOrder'];
    num area = data['area'];
    num capacity = data['capacity'];
    bool status = data['status'];
    num rating = data['rating'];
    List images = data['images'];

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
        minOrder: minOrder,
        maxOrder: maxOrder,
        area: area,
        capacity: capacity,
        status: status,
        rating: rating,
        images: images);
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
      'minOrder': minOrder,
      'maxOrder': maxOrder,
      'area': area,
      'capacity': capacity,
      'status': status,
      'rating': rating,
      'images': images,
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}

class ServiceFilter {
  String serviceType, serviceName, category;
  bool status;

  ServiceFilter({
    this.serviceType,
    this.serviceName,
    this.category,
    this.status,
  });
}
