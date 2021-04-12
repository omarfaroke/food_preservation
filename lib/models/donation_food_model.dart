import 'dart:convert';

import 'data_model.dart';

class DonationFoodModel extends DataModel {
  String id;
  String idRestaurant;
  String idVolunteer;
  String number;
  String description;
  String photo;
  String note;
  String phone;
  String location;
  String address;
  int dateAdd;
  int dateUpdate;
  String status;
  DonationFoodModel({
    this.id,
    this.idRestaurant,
    this.idVolunteer,
    this.number,
    this.description,
    this.photo,
    this.note,
    this.phone,
    this.location,
    this.address,
    this.dateAdd,
    this.dateUpdate,
    this.status,
  });

  @override
  fromJson(String source) => DonationFoodModel.fromJson(source);

  @override
  String get modelName => 'DonationFoodModel';

  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idRestaurant': idRestaurant,
      'idVolunteer': idVolunteer,
      'number': number,
      'description': description,
      'photo': photo,
      'note': note,
      'phone': phone,
      'location': location,
      'address': address,
      'dateAdd': dateAdd,
      'dateUpdate': dateUpdate,
      'status': status,
    };
  }

  factory DonationFoodModel.fromMap(Map<String, dynamic> map) {
    return DonationFoodModel(
      id: map['id'],
      idRestaurant: map['idRestaurant'],
      idVolunteer: map['idVolunteer'],
      number: map['number'],
      description: map['description'],
      photo: map['photo'],
      note: map['note'],
      phone: map['phone'],
      location: map['location'],
      address: map['address'],
      dateAdd: map['dateAdd'],
      dateUpdate: map['dateUpdate'],
      status: map['status'],
    );
  }

  factory DonationFoodModel.fromJson(String source) =>
      source == null ? null : DonationFoodModel.fromMap(json.decode(source));
}
