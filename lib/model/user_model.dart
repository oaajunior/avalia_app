import 'package:avalia_app/utils/type_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String name;
  String surName;
  String email;
  String password;
  TypeOfUser typeUser;
  Timestamp lastAccess;
  Timestamp createdAt;

  UserModel({
    this.name,
    this.surName,
    @required this.email,
    @required this.password,
    this.typeUser,
    this.lastAccess,
    this.createdAt,
  });
}
