//import 'package:final_project/pages/home_page.dart';
import 'package:final_project/services/authentication_service.dart';
import 'package:final_project/widgets/main_shell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/resident_person.dart';
import '../services/database_helper.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../app_theme.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{

  bool _isSubmitting = false;
  final _auth = AuthenticationService();
  final _db = DatabaseHelper();
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _submit() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final data = _formKey.currentState!.value;

    final username = (data['username'] as String).trim();
    final password = data['password'] as String;

    setState(() => _isSubmitting = true);
    try{
      final cred = await _auth.register(username, password);

      await _db.saveResidentPerson(
        cred.user!.uid,
        ResidentPersonRecordModel(
          username: username,
          roomNumber: int.parse(data['roomNumber'] as String),
          firstname: data['firstname']as String,
          lastname: data['lastname'] as String,
          registerDate: DateTime.now(),
        ),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthenticationService.messageFromCode(e.code))),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.background, AppTheme.sage, AppTheme.background],
          )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5 , sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withValues(alpha: 0.9),
                        border: Border.all(
                          color: AppTheme.sage.withValues(alpha: 0.8),
                        )
                      ),
                      child: Container(
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text('Register', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              SizedBox(height: 20,),
                              FormBuilderTextField(
                                name: 'roomNumber',
                                decoration: InputDecoration(
                                  labelText: 'Room Number',
                                  icon: Icon(Icons.door_back_door)
                                ),
                                // onChanged: (value) => person.roomNumber = int.tryParse(value ?? ''),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: 'Please Enter Your Room Number'),
                                  FormBuilderValidators.integer(errorText: 'Please Enter Only Integer')
                                ]
                                )
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: 'firstname',
                                decoration: InputDecoration(
                                  labelText: 'Firstname',
                                  icon: Icon(Icons.person)
                                ),
                                // onChanged: (value) => person.firstname = value,
                                validator: FormBuilderValidators.required(
                                  errorText: 'Please Enter Your Firstname'
                                )
                              ),
                              SizedBox(height: 20,),
                              FormBuilderTextField(
                                name: 'lastname',
                                decoration: InputDecoration(
                                  labelText: 'Lastname',
                                  icon: SizedBox(width: 24,)
                                ),
                                // onChanged: (value) => person.lastname = value,
                                validator: FormBuilderValidators.required(
                                  errorText: 'Please Enter Your Lastname'
                                )
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: 'username',
                                decoration: InputDecoration(
                                  labelText: 'username',
                                  icon: Icon(Icons.account_circle)
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: 'Please Enter Your Username'),
                                  FormBuilderValidators.match(
                                    RegExp(r'^[a-zA-Z0-9_.]+$'),
                                    errorText: "Please Input only characters, number, _"
                                  )
                                ]
                                )
                              ),
                              SizedBox(height: 20,),
                              FormBuilderTextField(
                                name: 'password',
                                obscureText: true,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(Icons.lock)
                                ),
                                 onChanged:(value) {
                                   final confirmField = _formKey.currentState?.fields['confirmPassword'];

                                   if(confirmField?.value != null && confirmField!.value.toString().isNotEmpty){
                                    confirmField.validate();
                                   }
                                 },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: "Please Enter Your Password"),
                                  FormBuilderValidators.minLength(8, errorText: "Password must be at least 8 characters")
                                ]
                                )
                              ),
                              SizedBox(height: 20,),
                              FormBuilderTextField(
                                name: 'confirmPassword',
                                obscureText: true,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  icon: SizedBox(width: 24)
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: 'Please Enter Your Password'),    
                                  (value){
                                    final password = _formKey.currentState?.fields['password']?.value;
                                      if (value != password){
                                        return "Password don't match";
                                      }
                                      return null;
                                  }
                                  ]
                                ),
                              ),
                              SizedBox(height: 20,),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.green,
                                    foregroundColor: AppTheme.surface,
                                  ),
                                  onPressed: _isSubmitting ? null : _submit,
                                  child: _isSubmitting
                                    ? const SizedBox(
                                      height: 20, width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2,)
                                    )
                                    : const Text("Register"),
                                )
                              ),
                              SizedBox(height: 20,),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.green,
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Login Page")
                                )
                            ]
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    );
  }
}
