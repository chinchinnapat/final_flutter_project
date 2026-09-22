import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/resident_reservation.dart';
import '../services/database_helper.dart';
import '../app_theme.dart';

class MyReservationPage extends StatefulWidget {
  const MyReservationPage({super.key});

  @override
  State<MyReservationPage> createState() => _MyReservationPageState();
}

class _MyReservationPageState extends State<MyReservationPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textDark,
        title: const Text("My Booking"),
      ),
      body: user == null
          ? const Center(child: Text("กรุณาเข้าสู่ระบบใหม่"))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: DatabaseHelper().streamMyReservations(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("ไม่สามารถโหลดรายการจองได้"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reservations = snapshot.data!.docs.map((doc) {
                  return ResidentReservationRecordModel.fromJson(
                    doc.data(),
                    id: doc.id,
                  );
                }).toList();

                if (reservations.isEmpty) {
                  return const Center(child: Text("ยังไม่มีการจอง"));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: reservations.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];
                    final start = reservation.startTime;
                    final end = reservation.endTime;
                    final isCancelled = reservation.status == 'cancelled';

                    final date = start == null
                        ? '-'
                        : '${start.day.toString().padLeft(2, '0')}/'
                              '${start.month.toString().padLeft(2, '0')}/'
                              '${start.year}';

                    final time = start == null || end == null
                        ? '-'
                        : '${start.hour.toString().padLeft(2, '0')}:'
                              '${start.minute.toString().padLeft(2, '0')} - '
                              '${end.hour.toString().padLeft(2, '0')}:'
                              '${end.minute.toString().padLeft(2, '0')}';

                    return Card(
                      color: AppTheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppTheme.sage,
                                  child: Icon(
                                    Icons.meeting_room,
                                    color: AppTheme.green,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Facility ID: ${reservation.facilityId ?? '-'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                isCancelled
                                    ? const Chip(
                                        backgroundColor: Color.fromARGB(255, 201, 201, 201),
                                        label: Text('ยกเลิกแล้ว'),
                                      )
                                    : OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppTheme.terracotta,
                                        ),
                                        onPressed: () async {
                                          if (reservation.id == null) return;

                                          final shouldCancel = await showDialog<bool>(
                                            context: context,
                                            builder: (dialogContext) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "ยืนยันการยกเลิก",
                                                ),
                                                content: const Text(
                                                  "คุณต้องการยกเลิกรายการจองนี้ใช่มั้ย",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        dialogContext,
                                                        false,
                                                      );
                                                    },
                                                    child: const Text(
                                                      "ไม่ยกเลิก", style: TextStyle(color: Colors.black),
                                                    ),
                                                  ),
                                                  FilledButton(
                                                    style:
                                                        FilledButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        dialogContext,
                                                        true,
                                                      );
                                                    },
                                                    child: const Text("ยืนยัน"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (shouldCancel != true) return;

                                          try {
                                            await DatabaseHelper()
                                                .cancelReservation(
                                                  reservation.id!,
                                                );

                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'ยกเลิกรายการจองแล้ว',
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'ยกเลิกไม่สำเร็จ: $e',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text('ยกเลิก'),
                                      ),
                              ],
                            ),

                            const Divider(height: 24),

                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: AppTheme.green,
                                ),
                                const SizedBox(width: 8),
                                Text(date),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: AppTheme.green,
                                ),
                                const SizedBox(width: 8),
                                Text(time),
                              ],
                            ),

                            if (reservation.confirmationCode != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                'รหัสยืนยัน: ${reservation.confirmationCode}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
