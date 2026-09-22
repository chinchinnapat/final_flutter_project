
import 'package:flutter/material.dart';
import 'cleanning_item.dart';
import 'electric_item.dart';
import 'miscellaneous_item.dart';
import 'sport_item.dart';
import 'room_item.dart';
import '../../app_theme.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.background,
          foregroundColor: AppTheme.textDark,
          leading:IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed:(){
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            "รายการของใช้ภายในหอพัก",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            labelColor: AppTheme.terracotta,
            unselectedLabelColor: AppTheme.green,
            indicatorColor: AppTheme.terracotta,
            tabs: [
              Tab(
                icon: Icon(Icons.electrical_services_outlined),
                text: "เครื่องใช้ไฟฟ้า"),
              Tab(
                icon: Icon(Icons.cleaning_services),
                text: "อุปกรณ์ทำความสะอาด",
              ),
              Tab(
                icon: Icon(Icons.sports), 
                text: "อุปกรณ์กีฬา"
              ),
              Tab(
               icon: Icon(Icons.more_horiz),
               text: "ของใช้จิปาถะ"
               ),
              Tab(
                icon:Icon(Icons.room),
                text: "ห้องส่วนกลาง",
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ElectricItem(),
            CleaningItem(),
            SportItem(),
            MiscellaneousItem(),
            RoomItem()
          ],
        ),
      ),
    );
  }
}
