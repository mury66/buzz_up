import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firebase/firestore/firestore_manager.dart';

// Stream provider for chat messages
final chatMessagesProvider = StreamProvider.family(
      (ref, String chatId) {
    return FirestoreManager().getMessages(chatId);
  },
);

final otherUserNameProvider = FutureProvider.family<String, String>(
      (ref, String chatId) async {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final otherUserName = await FirestoreManager().getOtherUserName(chatId, currentUid);
    return otherUserName;
  },
);
