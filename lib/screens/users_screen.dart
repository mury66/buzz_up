import 'package:buzz_up/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firestore/firestore_manager.dart';
import '../providers/users_provider.dart';

class UsersScreen extends ConsumerWidget {
  static const routeName = '/users';
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No other users found.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final u = users[index].data() as Map<String, dynamic>;
              final userInitial = (u['displayName'] as String).isNotEmpty
                  ? u['displayName'][0].toUpperCase()
                  : "?";

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  // Start chat
                  final chatId = await FirestoreManager().getOrCreateChat(
                    FirebaseAuth.instance.currentUser!.uid,
                    users[index].id,
                  );
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ChatScreen(chatId: chatId))
                  );
                },
                child: Card(
                  color: Colors.white12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.greenAccent.shade700,
                      child: Text(
                        userInitial,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      u['displayName'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      u['email'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chat_bubble,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
