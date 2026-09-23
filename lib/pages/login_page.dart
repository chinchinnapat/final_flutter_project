import 'package:final_project/pages/reset_password_page.dart';
import 'package:final_project/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:ui';
// import '../models/resident_person.dart';
import 'package:flutter/material.dart';
import 'package:final_project/pages/register_page.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthenticationService();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.4,
            colors: [AppTheme.background, AppTheme.sage],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withValues(alpha: 0.92),
                        border: Border.all(
                          color: AppTheme.sage.withValues(alpha: 0.8),
                        ),
                      ),
                      child: Container(
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 70,
                                backgroundImage: AssetImage(
                                  'assets/images/logo.png',
                                ),
                              ),
                              SizedBox(height: 35),
                              FormBuilderTextField(
                                name: 'username',
                                style: const TextStyle(color: AppTheme.textDark),
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  icon: Icon(Icons.account_circle),
                                ),
                                // onChanged: (value) => person.username = value,
                                validator: FormBuilderValidators.required(
                                  errorText: 'Please Enter Your Username',
                                ),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: 'password',
                                style: const TextStyle(color: AppTheme.textDark),
                                obscureText: _obscurePassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () => _obscurePassword = !_obscurePassword,
                                      );
                                    },
                                  ),
                                ),
                                // onChanged: (value) => person.password = value,
                                validator: FormBuilderValidators.required(
                                  errorText: 'Please Enter Your Password',
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.green,
                                    foregroundColor: AppTheme.surface,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!(_formKey.currentState
                                            ?.saveAndValidate() ??
                                        false))
                                      return;
                                    final data = _formKey.currentState!.value;
                                    try {
                                      await _auth.login(
                                        data['username'] as String,
                                        data['password'] as String,
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AuthenticationService.messageFromCode(
                                              e.code,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.green,
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ResetPasswordPage(),
                                  ),
                                ),
                                child: const Text("Forget Password"),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.green,
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                ),
                                child: const Text("Register"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
