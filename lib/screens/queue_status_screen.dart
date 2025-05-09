import 'package:flutter/material.dart';

class QueueStatusScreen extends StatelessWidget {
  const QueueStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queue Status"),
        backgroundColor: Color.fromARGB(255, 51, 221, 135),
      ),
      body: const Center(
        child: Text(
          "Queue Status Monitoring Coming Soon",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
