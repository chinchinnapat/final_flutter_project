import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/authentication_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../app_theme.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>{

  final _auth = AuthenticationService();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
  if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

  final username = _formKey.currentState!.value['username'] as String;
  setState(() => _isLoading = true);

  try {
    await _auth.resetPassword(username);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ส่งการรีเซ็ตรหัสผ่านไปที่อีเมลแล้ว')),
    );
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AuthenticationService.messageFromCode(e.code))),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textDark,
        title: const Text("Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'username',
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person)
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'กรุณา Username',
                ),
              ),
              const SizedBox(height: 24,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    foregroundColor: AppTheme.surface,
                  ),
                  onPressed: _isLoading ? null : _resetPassword, 
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("ส่งลิงก์รีเซ็ตรหัสผ่าน"),
                  )
              )
            ],
          )
        )
      )
    );
  }
}
