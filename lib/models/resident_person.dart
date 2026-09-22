import 'package:cloud_firestore/cloud_firestore.dart';

class ResidentPersonRecordModel {
  String? id;
  int? roomNumber;
  String? firstname;
  String? lastname;
  DateTime? registerDate;
  String? username;

  static const collectionName = "users";

  ResidentPersonRecordModel({
    required this.roomNumber,
    required this.firstname,
    required this.lastname,
    required this.registerDate,
    required this.username,
  });

  factory ResidentPersonRecordModel.fromJson(Map<String, dynamic> json) {
    return ResidentPersonRecordModel(
      roomNumber: json['roomNumber'],
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      registerDate: json['registerDate'] is Timestamp
        ? (json['registerDate'] as Timestamp).toDate()
        : null,
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'roomNumber': roomNumber,
      'firstname': firstname,
      'lastname': lastname,
      'registerDate': registerDate == null ? null : Timestamp.fromDate(registerDate!),
      'username': username,
    };
  }
}