import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../utils/app_colors.dart';

class JoinQueueScreen extends StatefulWidget {
  const JoinQueueScreen({super.key});

  @override
  State<JoinQueueScreen> createState() => _JoinQueueScreenState();
}

class _JoinQueueScreenState extends State<JoinQueueScreen> {
  final TextEditingController _serviceController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  bool isLoading = false;
  String? feedback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Queue"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Service",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(
                hintText: "Enter service (e.g. Fee Payment)",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleJoinQueue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Join Queue",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            if (feedback != null) ...[
              const SizedBox(height: 20),
              Text(feedback!,
                  style: const TextStyle(color: Colors.green, fontSize: 16)),
            ]
          ],
        ),
      ),
    );
  }

  void _handleJoinQueue() async {
    final service = _serviceController.text.trim();

    if (service.isEmpty) {
      setState(() => feedback = "Please enter a service.");
      return;
    }

    setState(() {
      isLoading = true;
      feedback = null;
    });

    try {
      // Auto-generate a pseudo token (in real world, you'd handle queue logic better)
      final token = DateTime.now().millisecondsSinceEpoch % 10000;

      // ✅ Firestore call to add the document with createdAt
      await _firestoreService.joinQueue(
        token: token,
        service: service,
      );

      setState(() {
        feedback = "Successfully joined the queue!";
        _serviceController.clear();
      });
    } catch (e) {
      setState(() => feedback = "Error: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }
}
