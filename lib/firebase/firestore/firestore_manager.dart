import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get chats => _firestore.collection('chats');



  // ======= Users =======

  Future<void> saveUserData({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<QueryDocumentSnapshot>> getUsers(String currentUid) {
    return users.snapshots().map(
            (snapshot) => snapshot.docs.where((doc) => doc.id != currentUid).toList());
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await users.doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  // ======= Chat =======
  Stream<List<QueryDocumentSnapshot>> getMessages(String chatId) {
    return chats.doc(chatId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> sendMessage(String chatId, Map<String, dynamic> message) async {
    await chats.doc(chatId).collection('messages').add(message);
    await chats.doc(chatId).update({
      'lastMessage': message['content'],
      'lastMessageTime': message['time'],
    });
  }

  Future<String> createChat(List<String> members) async {
    final chat = await chats.add({
      'members': members,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
    return chat.id;
  }

  Future<String> getOrCreateChat(String currentUid, String otherUid) async {
    final query = await chats.where('members', arrayContains: currentUid).get();

    for (var doc in query.docs) {
      final members = List<String>.from(doc['members']);
      if (members.contains(otherUid)) return doc.id;
    }

    return await createChat([currentUid, otherUid]);
  }

  // Get all chats for the current user, ordered by lastMessageTime
  Stream<List<QueryDocumentSnapshot>> getUserChats(String currentUid) {
    return chats
        .where('members', arrayContains: currentUid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<String> getOtherUserName(String chatId, String currentUid) async {
    final chatDoc = await chats.doc(chatId).get();
    final members = List<String>.from(chatDoc['members']);
    final otherUid = members.firstWhere((uid) => uid != currentUid);
    final userData = await getUserData(otherUid);
    return userData?['displayName'] ?? 'User';
  }
}
