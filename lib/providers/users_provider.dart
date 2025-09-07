import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firebase/firestore/firestore_manager.dart';

final usersProvider = StreamProvider((ref) {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  return FirestoreManager().getUsers(currentUserUid);
});
