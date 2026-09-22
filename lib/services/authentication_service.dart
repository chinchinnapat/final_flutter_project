import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  String? get uid => _auth.currentUser?.uid;

  Future<UserCredential> login(String username, String password) {
      return _auth.signInWithEmailAndPassword(
        email: '$username@gmail.com',
        password: password
        );
  }

  Future<UserCredential> register(String username, String password) {
    return _auth.createUserWithEmailAndPassword(
        email: '$username@gmail.com',
        password: password,
        );
  }

  Future<void> resetPassword(String username){
    return _auth.sendPasswordResetEmail(
      email: '${username.trim()}@gmail.com'
      );
  }  

  Future<void> logout() async{
    await _auth.signOut();
  }

  bool isAuthenticated(){
    return _auth.currentUser != null;
  }

  static String messageFromCode(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'ชื่อผู้ใช้นี้ถูกใช้แล้ว';
    case 'weak-password':
      return 'รหัสผ่านสั้นเกินไป ต้องอย่างน้อย 6 ตัวอักษร';
    case 'invalid-email':
      return 'ชื่อผู้ใช้ไม่ถูกต้อง';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
    default:
      return 'เกิดข้อผิดพลาด ($code)';
  }
}
}