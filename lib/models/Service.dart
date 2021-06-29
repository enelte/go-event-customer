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
  final int area, capacity, minOrder, maxOrder;
  final double price, rating;
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
    double price = data['price'];
    int minOrder = data['minOrder'];
    int maxOrder = data['maxOrder'];
    int area = data['area'];
    int capacity = data['capacity'];
    bool status = data['status'];
    double rating = data['rating'];
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
