import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/model/postmodel.dart';

final postFutureProvider = FutureProvider<List<PostModel>>((ref) async {
  final postRepository = PostRepository();
  return postRepository.getPostModelList();
});

class PostRepository {
  Future<List<PostModel>> getPostModelList() async {
    final CollectionReference postsCollection =
        FirebaseFirestore.instance.collection('Post');
    final QuerySnapshot querySnapshot = await postsCollection.get();

    final List<PostModel> postModelList = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return PostModel.fromMap(data, id);
    }).toList();

    return postModelList;
  }
}
