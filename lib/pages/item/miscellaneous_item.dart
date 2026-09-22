import 'package:flutter/material.dart';
import 'facilitiesList.dart';

class MiscellaneousItem extends StatelessWidget {
  const MiscellaneousItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const FacilityList(
      category: 'miscellaneous',
      emptyText: 'ยังไม่มีรายการของใช้จิปาถะ',
      icon: Icons.more_horiz,
    );
  }
}
