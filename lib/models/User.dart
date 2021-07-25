class UserModel {
  String uid;
  String email;
  String password;
  String displayName;
  String phoneNumber;
  String photoURL;
  String idCardURL;
  String selfieWithIdCardURL;
  String address;
  String city;
  String description;
  String role;
  String dateOfBirth;
  String bankName;
  String bankAccountNumber;
  String bankAccountName;
  bool registrationStatus;

  UserModel(
      {this.uid,
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
      this.idCardURL,
      this.selfieWithIdCardURL,
      this.registrationStatus,
      this.bankName,
      this.bankAccountNumber,
      this.bankAccountName});

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    if (data == null) {
      return null;
    }
    String email = data['email'];
    String displayName = data['displayName'];
    String phoneNumber = data['phoneNumber'];
    String photoURL = data['photoURL'];
    String idCardURL = data['idCardURL'];
    String selfieWithIdCardURL = data['selfieWithIdCardURL'];
    String address = data['address'];
    String city = data['city'];
    String description = data['description'];
    String role = data['role'];
    String dateOfBirth = data['dateOfBirth'];
    bool registrationStatus = data['registrationStatus'];
    String bankName = data['bankName'];
    String bankAccountName = data['bankAccountName'];
    String bankAccountNumber = data['bankAccountNumber'];

    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoURL: photoURL,
      idCardURL: idCardURL,
      selfieWithIdCardURL: selfieWithIdCardURL,
      address: address,
      city: city,
      description: description,
      role: role,
      dateOfBirth: dateOfBirth,
      registrationStatus: registrationStatus,
      bankName: bankName,
      bankAccountName: bankAccountName,
      bankAccountNumber: bankAccountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'idCardURL': idCardURL,
      'selfieWithIdCardURL': selfieWithIdCardURL,
      'address': address,
      'city': city,
      'description': description,
      'role': role,
      'dateOfBirth': dateOfBirth,
      'registrationStatus': registrationStatus,
      'bankName': bankName,
      'bankAccountName': bankAccountName,
      'bankAccountNumber': bankAccountNumber
    }..removeWhere(
        (dynamic key, dynamic value) => key == null || value == null);
  }
}
