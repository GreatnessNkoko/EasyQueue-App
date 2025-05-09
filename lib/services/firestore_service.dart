import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _queueRef = FirebaseFirestore.instance.collection('queue');

  Future<void> joinQueue({required int token, required String service}) async {
    await _queueRef.add({
      'token': token,
      'status': 'waiting',
      'service': service,
      'createdAt':
          FieldValue.serverTimestamp(), // ✅ This will now reflect in Firestore
    });
  }
}
