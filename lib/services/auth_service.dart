import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get authStateChanges => null;

  // Giriş Yap
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }
  }

  // Kayıt Ol
  Future<User?> signUp(String email, String password, String passwordConfirm) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }

  }

  // Çıkış Yap
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Hata Mesajları
  String _getErrorMessage(String code) {
    switch(code) {
      case 'invalid-email': return 'Geçersiz e-posta formatı';
      case 'user-disabled': return 'Kullanıcı engellendi';
      case 'user-not-found': return 'Kullanıcı bulunamadı';
      case 'wrong-password': return 'Yanlış şifre';
      case 'email-already-in-use': return 'Bu e-posta zaten kullanımda';
      case 'weak-password': return 'Şifre en az 6 karakter olmalı';
      default: return 'Bir hata oluştu';
    }
  }
}