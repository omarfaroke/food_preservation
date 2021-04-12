import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final String updatedAtKey = 'updatedAt';

final Map<String, dynamic> updatedAtField = {
  updatedAtKey: FieldValue.serverTimestamp()
};
