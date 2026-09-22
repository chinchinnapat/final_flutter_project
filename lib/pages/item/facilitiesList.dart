import 'package:flutter/material.dart';
import '../../../models/resident_facility.dart';
import '../../../services/database_helper.dart';
import '../../../pages/reservation_detail_page.dart';
import '../../app_theme.dart';

class FacilityList extends StatelessWidget {
  final String category;
  final String emptyText;
  final IconData icon;

  const FacilityList({
    super.key,
    required this.category,
    required this.emptyText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final database = DatabaseHelper();

    return FutureBuilder<List<ResidentFacilityRecordModel>>(
      future: database.getAllFacilities(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'เกิดข้อผิดพลาด: ${snapshot.error}',
            ),
          );
        }

        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(emptyText),
          );
        }

        
        final facilities = snapshot.data!
            .where(
              (facility) => facility.category == category,
            )
            .toList();

        
        if (facilities.isEmpty) {
          return Center(
            child: Text(emptyText),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: facilities.length,
          itemBuilder: (context, index) {
            final facility = facilities[index];

            return Card(
              color: AppTheme.surface,
              margin: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        facility.imagesAsset!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        
                        Text(
                          facility.name ??
                              'ไม่มีชื่อรายการ',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),

                        const SizedBox(height: 8),

                       
                        if (facility.description != null &&
                            facility.description!.isNotEmpty)
                          Text(
                            facility.description!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textDark,
                            ),
                          ),

                        const SizedBox(height: 8),

                        
                        if (category == 'moving_room')
                          Text(
                            'รองรับได้ '
                            '${facility.capacity ?? 0} คน',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textDark,
                            ),
                          ),

                        
                        Text(
                          'เวลา '
                          '${facility.openHour ?? 0}:00 - '
                          '${facility.closeHour ?? 0}:00',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textDark,
                          ),
                        ),

                        const SizedBox(height: 14),

                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.green,
                              foregroundColor: AppTheme.surface,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReservationDetailPage(
                                    facility: facility,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'จอง',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

