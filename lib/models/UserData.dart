class UserDataModel {
  String uid;
  String displayName;
  String phoneNumber;
  String photoURL;
  String address;
  String city;
  String description;
  String role;
  String dateOfBirth;

  UserDataModel(
      {this.uid,
      this.displayName,
      this.phoneNumber,
      this.photoURL,
      this.address,
      this.city,
      this.description,
      this.role,
      this.dateOfBirth});

  factory UserDataModel.fromMap(Map<String, dynamic> data, String uid) {
    if (data == null) {
      return null;
    }
    String displayName = data['displayName'];
    String phoneNumber = data['phoneNumber'];
    String photoURL = data['photoURL'];
    String address = data['address'];
    String city = data['city'];
    String description = data['description'];
    String role = data['role'];
    String dateOfBirth = data['dateOfBirth'];

    return UserDataModel(
        uid: uid,
        displayName: displayName,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
        address: address,
        city: city,
        description: description,
        role: role,
        dateOfBirth: dateOfBirth);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'address': address,
      'city': city,
      'description': description,
      'role': role,
      'dateOfBirth': dateOfBirth
    };
  }
}
