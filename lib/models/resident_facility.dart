//import 'package:cloud_firestore/cloud_firestore.dart';

class ResidentFacilityRecordModel {
  String? id;
  String? name;
  String? category;
  String? description;
  int? capacity;
  int? openHour;
  int? closeHour;
  String? imagesAsset;
  bool isAvailable = true;

  static const String collectionName = 'facilities';

  ResidentFacilityRecordModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.capacity,
    required this.openHour,
    required this.closeHour,
    required this.imagesAsset,
  });

  factory ResidentFacilityRecordModel.fromJson(Map<String, dynamic> json, {String? id}){
    return ResidentFacilityRecordModel(
      id: id,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      capacity: json['capacity'] ?? 1,
      openHour: json['openHour'],
      closeHour: json['closeHour'],
      imagesAsset: json['imagesAsset'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'category': category,
      'description': description,
      'capacity': capacity,
      'openHour': openHour,
      'closeHour': closeHour,
      'imagesAsset': imagesAsset,
    };
  }
}