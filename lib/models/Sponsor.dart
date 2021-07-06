class Sponsor {
  final String sponsorId,
      sponsorName,
      email,
      phoneNumber,
      businessField,
      description;

  Sponsor(
      {this.sponsorId,
      this.sponsorName,
      this.email,
      this.phoneNumber,
      this.businessField,
      this.description});

  factory Sponsor.fromMap(Map<String, dynamic> data, String sponsorId) {
    if (data == null) {
      return null;
    }
    String sponsorName = data['sponsorName'];
    String email = data['email'];
    String phoneNumber = data['phoneNumber'];
    String businessField = data['businessField'];
    String description = data['description'];

    return Sponsor(
        sponsorId: sponsorId,
        sponsorName: sponsorName,
        email: email,
        phoneNumber: phoneNumber,
        businessField: businessField,
        description: description);
  }

  Map<String, dynamic> toMap() {
    return {
      "sponsorName": sponsorName,
      "email": email,
      "phoneNumber": phoneNumber,
      "businessField": businessField,
      "description": description
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
