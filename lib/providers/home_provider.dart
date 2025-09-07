// chats_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firebase/firestore/firestore_manager.dart';

// StreamProvider for user's chats
final userChatsProvider = StreamProvider((ref) {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  return FirestoreManager().getUserChats(currentUserUid);
});