import 'package:avalia_app/utils/type_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String surName;
  String email;
  String password;
  TypeOfUser typeUser;
  Timestamp createdAt;

  UserModel({
    this.id,
    this.name,
    this.surName,
    this.email,
    this.password,
    this.typeUser,
    this.createdAt,
  });

  UserModel.fromMap(
    String userId,
    Map<String, dynamic> user,
  )   : id = userId,
        name = user['username'],
        surName = user['surname'],
        email = user['email'],
        typeUser =
            user['type_user'] == 'T' ? TypeOfUser.Teacher : TypeOfUser.Student;

  Map<String, dynamic> toMap() => {
        'username': this.name,
        'surname': this.surName,
        'email': this.email,
        'type_user': this.typeUser == TypeOfUser.Teacher ? 'T' : 'S',
        'create_at': FieldValue.serverTimestamp(),
      };
}
