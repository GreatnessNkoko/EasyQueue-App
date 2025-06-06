import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../screens/join_queue_screen.dart';
import '../screens/queue_status_screen.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? "Student";
    final queueStream = FirestoreService().getUserQueueStream();
    final userId = user?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello, $userName 👋",
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text("Welcome to EasyQueue",
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_active_rounded,
                      color: Colors.white, size: 28),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add_circle_outline,
                              color: primaryColor),
                          title: const Text("Join Queue"),
                          subtitle: const Text("Register for services"),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const JoinQueueScreen()),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.queue, color: primaryColor),
                          title: const Text("View Queue Status"),
                          subtitle: const Text("Check your queue position"),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const QueueStatusScreen()),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading:
                              const Icon(Icons.payment, color: primaryColor),
                          title: const Text("Pay Fees"),
                          subtitle: const Text("Feature Coming Soon"),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Fee payment page is not yet available."),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Your Queue Status",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
  StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('queue')
      .where('userId', isEqualTo: userId) // 🔥 Filter queue by user
      .orderBy('createdAt', descending: false)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Text("You haven't joined any queue yet.");
    }

    final queues = snapshot.data!.docs;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: queues.length,
      itemBuilder: (context, index) {
        final queueData = queues[index].data() as Map<String, dynamic>;

        return Card(
          color: Colors.grey[100],
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor,
              child: Text(queueData['token'].toString()),
            ),
            title: Text(queueData['service'] ?? "Service"),
            subtitle: Text("Status: ${queueData['status']}"),
          ),
        );
      },
    );
  },
),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Transactions"),
        ],
      ),
    );
  }
}
