class ServiceType {
  final String name, unit;
  final List category;

  ServiceType({
    this.name,
    this.unit,
    this.category,
  });

  factory ServiceType.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String name = data['name'];
    String unit = data['unit'];
    List category = data['category'];

    return ServiceType(
      name: name,
      unit: unit,
      category: category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "unit": unit,
      "category": category,
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
