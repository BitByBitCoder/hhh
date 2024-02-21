import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/model/usermodel.dart';

final setUserRoleProvider = Provider((ref) => UserModelRepository());
final userModelListProvider = FutureProvider<List<UserModel>>((ref) {
  return UserModelRepository().getUserModelList();
});

class UserModelRepository {
  Future<List<UserModel>> getUserModelList() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    final QuerySnapshot querySnapshot = await usersCollection.get();

    final List<UserModel> userModelList = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;

      return UserModel.fromMap(data, id);
    }).toList();

    return userModelList;
  }

  Future<void> setUserRole(String uid, bool pro) async {
    final userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);

    try {
      print('tessssss $pro');
      await userDocRef.update({
        'moderator': pro,
      });
      print('User role updated successfully!');
    } catch (e) {
      print('Error updating user role: $e');
    }
  }
}
