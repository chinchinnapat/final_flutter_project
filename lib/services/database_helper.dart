import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/resident_person.dart';
import '../models/resident_facility.dart';
import '../models/resident_reservation.dart';
import 'dart:math';

class DatabaseHelper {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
    _db.collection(ResidentPersonRecordModel.collectionName);

  CollectionReference<Map<String, dynamic>> get _facilities =>
    _db.collection(ResidentFacilityRecordModel.collectionName);

  CollectionReference<Map<String, dynamic>> get _reservations =>
    _db.collection(ResidentReservationRecordModel.collectionName);

  Future<void> saveResidentPerson(String uid, ResidentPersonRecordModel person) {
    return _users.doc(uid).set(person.toJson());
  }

  Future<ResidentPersonRecordModel?> getResidentPerson(String uid) async {
    final snap = await _users.doc(uid).get();
    if (!snap.exists) return null;
    return ResidentPersonRecordModel.fromJson(snap.data()!);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamResidentPerson(String uid){
    return _users.doc(uid).snapshots();
  }

  Future<List<ResidentFacilityRecordModel>> getAllFacilities() async {
    final snap = await _facilities.get();
    return snap.docs
        .map((doc) => ResidentFacilityRecordModel.fromJson(
          doc.data(), 
          id: doc.id
          ))
        .toList();
  }
  
  // Stream<List<ResidentFacilityRecordModel>> streamFacilitiesWithStatus(
  //   List<ResidentFacilityRecordModel> allFacilities,
  // ){
  //   return _reservations
  //       .where('status', isEqualTo: 'booked')
  //       .snapshots()
  //       .map((snapshot){
  //         final now = DateTime.now();

  //         final busyFacilityIds = <String>{};

  //         for (final doc in snapshot.docs){
  //           final r = ResidentReservationRecordModel.fromJson(doc.data(), id: doc.id);
  //           if(r.startTime == null || r.endTime == null) continue;
  //           if(r.startTime!.isBefore(now) && r.endTime!.isAfter(now)){
  //             busyFacilityIds.add(r.facilityId ?? '');
  //           }
  //         }

  //         return allFacilities.map((f){
  //           final isBusy = busyFacilityIds.contains(f.id);
            
  //           return ResidentFacilityRecordModel(
  //             id: f.id,
  //             name: f.name,
  //             category: f.category,
  //             description: f.description,
  //             capacity: f.capacity,
  //             openHour: f.openHour,
  //             closeHour: f.closeHour,
  //             imagesAsset: f.imagesAsset,  
  //           )..isAvailable = !isBusy;
  //         }).toList();
  //       });
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMyReservations(String uid){
    return _reservations
      .where('uid', isEqualTo: uid)
      .orderBy('startTime', descending: true)
      .snapshots();
  }

  Future<void> bookSlot(ResidentReservationRecordModel reservation) async{
    final slotId = ResidentReservationRecordModel.slotId(
      reservation.facilityId!,
      reservation.startTime!,
    );
    final ref = _reservations.doc(slotId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if(snap.exists && snap.data()?['status'] == 'booked'){
        throw Exception("ช่วงเวลานี้ถูกจองไปแล้ว");
      }
      reservation.id = slotId;
      tx.set(ref, reservation.toJson());
    });
  }

  Future<void> cancelReservation(String reservationId){
    return _reservations.doc(reservationId).update({'status': 'cancelled'});
  }

  // Future<void> rescheduleReservation({
  //   required ResidentReservationRecordModel oldReservation,
  //   required DateTime newStart,
  //   required DateTime newEnd,
  // }) async {
  //   final newSlotId = ResidentReservationRecordModel.slotId(
  //     oldReservation.facilityId!,
  //     newStart,
  //   );
    
  //   final newRef = _reservations.doc(newSlotId);
  //   final oldRef = _reservations.doc(oldReservation.id);

  //   await _db.runTransaction((tx) async {
  //     final newSnap = await tx.get(newRef);
  //     if(newSnap.exists && newSnap.data()?['status'] == 'booked'){
  //       throw Exception('ช่วงเวลาใหม่นี้ถูกจองแล้ว');
  //     }

  //     tx.update(oldRef, {'status': 'cancelled'});

  //     final newReservation = ResidentReservationRecordModel(
  //       id: newSlotId,
  //       uid: oldReservation.uid,
  //       facilityId: oldReservation.facilityId,
  //       startTime: newStart,
  //       endTime: newEnd,
  //       residentName: oldReservation.residentName,
  //       roomNumber: oldReservation.roomNumber,
  //       confirmationCode: oldReservation.confirmationCode,
  //       status: 'booked',
  //     );
  //     tx.set(newRef, newReservation.toJson());
  //   });
  // }

  String generateConfirmationCode(){
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(8, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}