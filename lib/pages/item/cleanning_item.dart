import 'package:flutter/material.dart';
import 'facilitiesList.dart';

class CleaningItem extends StatelessWidget {
  const CleaningItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const FacilityList(
      category: 'cleaning_tool',
      emptyText: 'ยังไม่มีรายการอุปกรณ์ทำความสะอาด',
      icon: Icons.cleaning_services,
    );
  }
}
