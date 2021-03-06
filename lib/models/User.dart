class UserModel {
  String uid;
  String email;
  String password;
  String displayName;
  String phoneNumber;
  String photoURL;
  String address;
  String city;
  String description;
  String role;
  String dateOfBirth;

  UserModel({
    this.uid,
    this.email,
    this.password,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.address,
    this.city,
    this.description,
    this.role,
    this.dateOfBirth,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    if (data == null) {
      return null;
    }
    String email = data['email'];
    String displayName = data['displayName'];
    String phoneNumber = data['phoneNumber'];
    String photoURL = data['photoURL'];
    String address = data['address'];
    String city = data['city'];
    String description = data['description'];
    String role = data['role'];
    String dateOfBirth = data['dateOfBirth'];

    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoURL: photoURL,
      address: address,
      city: city,
      description: description,
      role: role,
      dateOfBirth: dateOfBirth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'address': address,
      'city': city,
      'description': description,
      'role': role,
      'dateOfBirth': dateOfBirth,
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
