import 'package:flutter/material.dart';
import 'facilitiesList.dart';

class ElectricItem extends StatelessWidget {
  const ElectricItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const FacilityList(
      category: 'electric',
      emptyText: 'ยังไม่มีรายการเครื่องใช้ไฟฟ้า',
      icon: Icons.electrical_services,
    );
  }
}
