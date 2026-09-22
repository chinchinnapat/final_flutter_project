import 'package:flutter/material.dart';
import 'facilitiesList.dart';

class SportItem extends StatelessWidget {
  const SportItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const FacilityList(
      category: 'sport',
      emptyText: 'ยังไม่มีรายการอุปกรณ์กีฬา',
      icon: Icons.sports,
    );
  }
}