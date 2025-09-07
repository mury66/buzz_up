import 'package:buzz_up/screens/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firebase/firestore/firestore_manager.dart';
import '../providers/home_provider.dart';
import 'chat_screen.dart';

class HomeScreen extends ConsumerWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(userChatsProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BuzzUp'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              accountName: Text(
                currentUser?.displayName ?? "Guest User",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                currentUser?.email ?? "No email",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white24,
                child: Text(
                  (currentUser?.displayName != null &&
                          currentUser!.displayName!.isNotEmpty)
                      ? currentUser.displayName![0].toUpperCase()
                      : "?",
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => _logout(context),
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.red),
              title: const Text("Users"),
              onTap: () {
                Navigator.pushNamed(context, UsersScreen.routeName);
              },
            ),
          ],
        ),
      ),
      body: chatsAsync.when(
        data: (chats) {
          if (chats.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final members = List<String>.from(chat['members']);
                final otherUserId = members.firstWhere(
                  (uid) => uid != currentUser!.uid,
                );

                return FutureBuilder(
                  future: FirestoreManager().getUserData(otherUserId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final otherUser = snapshot.data!;
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: chat.id,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black54,
                            child: Text(
                              otherUser['displayName'][0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(otherUser['displayName']),
                          subtitle: Text(chat['lastMessage'] ?? ""),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          print(e.toString());
          return Center(child: Text('Errorrrrrrrr: $e'));
        },
      ),
    );
  }
}
