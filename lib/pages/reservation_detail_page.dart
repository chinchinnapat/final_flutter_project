
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/models/resident_facility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/models/resident_reservation.dart';
import 'package:final_project/services/database_helper.dart';
import '../app_theme.dart';

class ReservationDetailPage extends StatefulWidget {
  const ReservationDetailPage({super.key, required this.facility});

  final ResidentFacilityRecordModel facility;

  @override
  State<ReservationDetailPage> createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  DateTime selectedDate = DateTime.now();
  String selectedSlot = '18:00 - 19:00';
  bool isFavorite = false;

  final slots = [
    '09:00 - 10:00',
    '10:00 - 11:00',
    '13:00 - 14:00',
    '16:00 - 17:00',
    '18:00 - 19:00',
    '19:00 - 20:00',
    '20:00 - 21:00',
  ];

  Future<void> pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('EEE, d MMM', 'th').format(selectedDate);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppTheme.green,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: AppTheme.surface,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        widget.facility.imagesAsset ?? 'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const ColoredBox(color: AppTheme.green);
                        },
                      ),

                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x99000000)],
                          ),
                        ),
                      ),

                      const Align(
                        alignment: Alignment(0, 0.65),
                        child: Text(
                          'RESIDENT SERVICE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0, -20, 0),
                  padding: const EdgeInsets.fromLTRB(24, 26, 24, 120),
                  decoration: const BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.facility.name ?? '-',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 22),
                        child: Divider(),
                      ),
                      const Text(
                        'รายละเอียด',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.facility.description?.isNotEmpty == true
                          ? widget.facility.description!
                          : "ไม่มีคำอธิบายเพิ่มเติม",
                        style: const TextStyle(height: 1.5, color: AppTheme.textDark),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'เลือกวันและเวลา',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: pickDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(dateText),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: slots.map((slot) {
                          return ChoiceChip(
                            label: Text(slot),
                            selected: selectedSlot == slot,
                            selectedColor: AppTheme.sage,
                            onSelected: (_) {
                              setState(() => selectedSlot = slot);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                color: AppTheme.surface,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    minimumSize: const Size.fromHeight(54),
                  ),
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null || widget.facility.id == null) return;

                    final timeParts = selectedSlot.split(' - ');
                    final startHour = int.parse(timeParts[0].split(":")[0]);
                    final endHour = int.parse(timeParts[1].split(":")[0]);

                    final startTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      startHour,
                    );

                    final endTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      endHour,
                    );

                    try {
                      final database = DatabaseHelper();
                      final resident = await database.getResidentPerson(
                        user.uid,
                      );

                      final reservation = ResidentReservationRecordModel(
                        id: null,
                        uid: user.uid,
                        facilityId: widget.facility.id,
                        startTime: startTime,
                        endTime: endTime,
                        residentName:
                            '${resident?.firstname ?? ''} ${resident?.lastname ?? ''}'
                                .trim(),
                        roomNumber: resident?.roomNumber ?? 0,
                        confirmationCode: database.generateConfirmationCode(),
                        status: 'booked',
                      );

                      await database.bookSlot(reservation);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("จองพื้นที่สำเร็จ")),
                        );

                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("จองไม่สำเร็จ: $e")),
                        );
                      }
                    }
                  },
                  child: const Text("จองพื้นที่นี้"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
