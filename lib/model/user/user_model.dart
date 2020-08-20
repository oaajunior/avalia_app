import 'package:avalia_app/utils/type_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String surName;
  String email;
  String password;
  TypeOfUser typeUser;
  Timestamp createdAt;

  UserModel({
    this.name,
    this.surName,
    this.email,
    this.password,
    this.typeUser,
    this.createdAt,
  });
}
