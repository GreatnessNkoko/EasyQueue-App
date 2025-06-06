import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  
  var userId;

  Future<void> joinQueue({required int token, required String service}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    await FirebaseFirestore.instance.collection('queue').add({
      'uid': user.uid,
      'token': token,
      'service': service,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUserQueueStream() {
    return _db
        .collection('queue')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }
}
