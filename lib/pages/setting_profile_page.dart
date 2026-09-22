import 'package:final_project/models/resident_person.dart';
import 'package:final_project/pages/grorp_page.dart';
import 'package:final_project/pages/reset_password_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_theme.dart';

class SettingProfilePage extends StatefulWidget {
  const SettingProfilePage({super.key});

  @override
  State<SettingProfilePage> createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textDark,
        title: const Text("Settings and Privacy"),
      ),
      body: user == null
          ? const Center(child: Text("กรุณาเข้าสู่ระบบใหม่"))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: DatabaseHelper().streamResidentPerson(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.data!.exists) {
                  return Center(
                    child: Text("ไม่พบข้อมูลผู้ใช้งาน: ${snapshot.error}"),
                  );
                }

                final residentPerson = ResidentPersonRecordModel.fromJson(
                  snapshot.data!.data()!,
                );

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AppTheme.sage,
                      child: const Icon(
                        Icons.person,
                        size: 42,
                        color: AppTheme.green,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: Text(
                        '${residentPerson.roomNumber}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        '${residentPerson.firstname ?? ''}\t'
                        '${residentPerson.lastname ?? ''}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ListTile(
                      leading: const Icon(
                        Icons.account_circle,
                        color: AppTheme.green,
                      ),
                      title: const Text("Username"),
                      trailing: Text(
                        '${residentPerson.username}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppTheme.green,
                        ),
                      ),
                    ),
                    const Divider(color: AppTheme.sage),
                    ListTile(
                      leading: const Icon(Icons.lock, color: AppTheme.green),
                      title: const Text("Change Password"),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppTheme.green,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResetPasswordPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(color: AppTheme.sage),
                    ListTile(
                      leading: const Icon(Icons.group, color: AppTheme.green),
                      title: const Text("Group Detail"),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppTheme.green,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => GroupPage()),
                      ),
                    ),
                    const Divider(color: AppTheme.sage),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: AppTheme.terracotta,
                      ),
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: AppTheme.terracotta),
                      ),
                      onTap: () async {
                        final confirmLogOut = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text("ยันยันการยกเลิก"),
                              content: const Text(
                                "คุณต้องการยกเลิกรายการจองนี้ใช่มั้ย",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext, false);
                                  },
                                  child: const Text("ยกเลิก", style: TextStyle(color: Colors.black)),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(dialogContext, true);
                                  },
                                  child: const Text(
                                    "ยืนยัน",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmLogOut == true) {
                          await FirebaseAuth.instance.signOut();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }
}
