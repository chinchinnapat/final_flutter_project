import 'package:flutter/material.dart';
import '../app_theme.dart';

class GroupPage extends StatelessWidget{
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textDark,
        title: Center(
          child: Text("Group Detail")
          ),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("assets/images/chin.jpg"),
                ),
                const SizedBox(height: 5,),
                ListTile(
                  leading: const Icon(Icons.person, color: AppTheme.green),
                  title: const Text("รายละเอียด", style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textDark),)
                ),
                const SizedBox(height: 2,),
                ListTile(
                  leading: SizedBox(width: 24,),
                  title: const Text("6721602318")
                ),
                const SizedBox(height: 2,),
                ListTile(
                  leading: SizedBox(width: 24,),
                  title: const Text("ชินภัทร เพชรแดง")
                ),
                const SizedBox(height: 2,),
                ListTile(
                  leading: SizedBox(width: 24),
                  title: const Text("เลขที่ 5")
                ),
                const SizedBox(height: 24,),
                const Divider(color: AppTheme.sage),
                const SizedBox(height: 24,),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("assets/images/july.jpg"),
                ),
                const SizedBox(height: 5,),
                ListTile(
                  leading: const Icon(Icons.person, color: AppTheme.green),
                  title: const Text("รายละเอียด", style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textDark),)
                ),
                const SizedBox(height: 2,),
                ListTile(
                  leading: SizedBox(width: 24,),
                  title: const Text("6721602491 ")
                ),
                const SizedBox(height: 2,),
                ListTile(
                  leading: SizedBox(width: 24,),
                  title: const Text("ปรารวี ชนะเนตร")
                ),
                const SizedBox(height: 2,),
                ListTile(
                  leading: SizedBox(width: 24),
                  title: const Text("เลขที่ 21")
                ),
              ]
                )
              
            )
          )
        ),
      );
  }
}
