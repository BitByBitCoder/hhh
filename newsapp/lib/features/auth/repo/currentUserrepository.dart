import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/model/currentUserModel.dart';

final futureCurrentUserProvider = FutureProvider.family((ref, String uid) {
  final repository = ref.watch(currentrepositoryProvider);
  return repository.fetchCurrentUser();
});

final currentrepositoryProvider = Provider((ref) {
  return CurrentUserRepository();
});

class CurrentUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CurrentUser> fetchCurrentUser() async {
    try {
      final useruid = await FirebaseAuth.instance.currentUser?.uid;
      DocumentSnapshot userSnapshot =
          await _firestore.collection('Users').doc(useruid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        print(userData);
        return CurrentUser.fromJson(userData);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
