import 'package:cloud_firestore/cloud_firestore.dart';

class ResidentReservationRecordModel{
  String? id;
  String? uid;
  String? facilityId;
  DateTime? startTime;
  DateTime? endTime;
  String? residentName;
  int? roomNumber;
  String? confirmationCode;
  String? status;

  static const collectionName = "reservations";

  ResidentReservationRecordModel({
    required this.id,
    required this.uid,
    required this.facilityId,
    required this.startTime,
    required this.endTime,
    required this.residentName,
    required this.roomNumber,
    required this.confirmationCode,
    required this.status
  });

  static String slotId(String facilityId, DateTime slotStart){
    final date = '${slotStart.year}-'
      '${slotStart.month.toString().padLeft(2, '0')}-'
      '${slotStart.day.toString().padLeft(2, '0')}';
    return '${facilityId}_${date}_${slotStart.hour.toString().padLeft(2, '0')}';
  }

  factory ResidentReservationRecordModel.fromJson(Map<String, dynamic> json, {String? id}){
    return ResidentReservationRecordModel(
      id: id,
      uid: json['uid'] ?? '',
      facilityId: json['facilityId'] ?? '',
      startTime: json['startTime'] is Timestamp
        ? (json['startTime'] as Timestamp).toDate()
        : null,
      endTime: json['endTime'] is Timestamp
        ? (json['endTime'] as Timestamp).toDate()
        :null,
      residentName: json['residentName'] ?? '',
      roomNumber: json['roomNumber'] ?? 0,
      confirmationCode: json['confirmationCode'] ?? '',
      status: json['status'] ?? 'booked',
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'uid': uid,
      'facilityId': facilityId,
      'startTime': startTime,
      'endTime': endTime,
      'residentName': residentName,
      'roomNumber': roomNumber,
      'confirmationCode': confirmationCode,
      'status': status,
    };
  }
}