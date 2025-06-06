import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _updateStatus(
      String docId, String field, String newValue) async {
    await FirebaseFirestore.instance.collection('queue').doc(docId).update({
      field: newValue,
    });
  }

  Future<void> _deleteQueue(String docId) async {
    await FirebaseFirestore.instance.collection('queue').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('queue')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No queues found."));
          }

          final queues = snapshot.data!.docs;

          return ListView.builder(
            itemCount: queues.length,
            itemBuilder: (context, index) {
              final doc = queues[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Text('${data['token'] ?? '#'}'),
                  ),
                  title: Text(data['service'] ?? 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${data['status']}'),
                      Text('UID: ${data['uid']}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'approve') {
                        _updateStatus(doc.id, 'status', 'approved');
                      } else if (value == 'pending') {
                        _updateStatus(doc.id, 'status', 'pending');
                      } else if (value == 'delete') {
                        _deleteQueue(doc.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'approve', child: Text('Approve')),
                      const PopupMenuItem(
                          value: 'pending', child: Text('Set Pending')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
