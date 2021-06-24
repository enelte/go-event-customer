import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String uid;
  final String email;

  UserModel({@required this.uid, this.email});
}
