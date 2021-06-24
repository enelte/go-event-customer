class Service {
  final String serviceId, vendorId, serviceType, serviceName, description;
  final List images;
  final int price, area, capacity, minOrder, maxOrder;
  final double rating;
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
      this.rating});

  factory Service.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String serviceId = documentId;
    String vendorId = data['vendorId'];
    String serviceType = data['serviceType'];
    String serviceName = data['serviceName'];
    String description = data['description'];
    int price = data['price'];
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
        price: price,
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
      'serviceId': serviceId,
      'vendorId': vendorId,
      'serviceType': serviceType,
      'serviceName': serviceName,
      'description': description,
      'price': price,
      'minOrder': minOrder,
      'maxOrder': maxOrder,
      'area': area,
      'capacity': capacity,
      'status': status,
      'rating': rating,
      'images': images
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}

List<Service> services = [
  Service(
    serviceId: "1",
    serviceName: "Kassandra Ballroom - Max. 100 Pax",
    price: 880000,
    area: 12,
    rating: 4.5,
    description: dummyText,
    images: ["assets/images/service_1.jpg"],
  ),
  Service(
    serviceId: "2",
    serviceName: "Ballroom Biasa",
    price: 1790000,
    area: 8,
    rating: 4.5,
    description: dummyText,
    images: ["assets/images/service_2.jpg"],
  ),
  Service(
    serviceId: "3",
    serviceName: "Rameses Ballroom - Max. 1000 Pax",
    price: 2690000,
    area: 10,
    rating: 4.5,
    description: dummyText,
    images: ["assets/images/image_banner.png"],
  ),
  Service(
    serviceId: "4",
    serviceName: "Rameses Ballroom - Max. 1000 Pax",
    price: 2690000,
    area: 11,
    rating: 4.5,
    description: dummyText,
    images: ["assets/images/service_1.jpg"],
  ),
  Service(
    serviceId: "5",
    serviceName: "Rameses Ballroom - Max. 1000 Pax",
    price: 2690000,
    area: 12,
    rating: 4.5,
    description: dummyText,
    images: ["assets/images/service_2.jpg"],
  ),
  Service(
    serviceId: "6",
    serviceName: "Rameses Ballroom - Max. 1000 Pax",
    price: 2690000,
    area: 12,
    rating: 4.5,
    description: dummyText,
    images: ["assets/images/image_banner.png"],
  ),
  Service(
    serviceId: "7",
    serviceName: "Rameses Ballroom - Max. 1000 Pax",
    price: 2690000,
    area: 12,
    rating: 4.5,
    description: dummyText,
    images: ["assets/images/image_banner.png"],
  ),
  Service(
    serviceId: "8",
    serviceName: "Rameses Ballroom - Max. 1000 Pax",
    price: 2690000,
    area: 12,
    rating: 4.5,
    description: dummyText,
    images: ["assets/images/image_banner.png"],
  ),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and serviceTypesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
