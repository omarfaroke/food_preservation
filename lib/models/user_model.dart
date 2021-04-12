import 'dart:convert';
import 'data_model.dart';

class UserModel extends DataModel {
  String id;
  String name;
  String email;
  String phone;
  String photo;
  String address;
  String location;
  String note;
  String status;
  int type;
  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
    this.address,
    this.location,
    this.note,
    this.type,
    this.status,
  });

  @override
  fromJson(String source) => UserModel.fromJson(source);

  @override
  String get modelName => 'UserModel';

  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'address': address,
      'location': location,
      'note': note,
      'type': type,
      'status': status,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      photo: map['photo'],
      address: map['address'],
      location: map['location'],
      note: map['note'],
      type: map['type'],
      status: map['status'],
    );
  }

  factory UserModel.fromJson(String source) =>
      source == null ? null : UserModel.fromMap(json.decode(source));
}
