import 'package:firebase_auth/firebase_auth.dart';

class FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  // Stream لحالة المستخدم (مفيد للتنقل بين Login / Home)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // تسجيل مستخدم جديد
  Future<User?> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user?.updateDisplayName(displayName);
      await cred.user?.reload();

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Registration failed");
    }
  }

  // تسجيل دخول
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  // تسجيل خروج
  Future<void> logout() async {
    await _auth.signOut();
  }
}
