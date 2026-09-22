import 'package:flutter/material.dart';
import 'facilitiesList.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const FacilityList(
      category: 'moving_room',
      emptyText: 'ยังไม่มีรายการห้อง',
      icon: Icons.meeting_room,
    );
  }
}