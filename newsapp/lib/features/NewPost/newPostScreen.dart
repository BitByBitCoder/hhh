import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/features/home/repository/post.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _moderatorNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pictureController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _moderatorNameController.dispose();
    _descriptionController.dispose();
    _pictureController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      final userUid = user?.uid ?? '';
      final newPostData = {
        'title': _titleController.text,
        'moderatorName': _moderatorNameController.text,
        'moderatorUid': userUid,
        'description': _descriptionController.text,
        'picture': _pictureController.text,
        'createdAt': Timestamp.now(),
      };

      final CollectionReference postsCollection =
          FirebaseFirestore.instance.collection('Post');
      final documentRef = await postsCollection.add(newPostData);
      final documentId = documentRef.id;

// final commentsCollection = documentRef.collection('comments');
// await commentsCollection.add({
//   'uid': userUid,
//   'username': username,
//   'message': message,
// });

      await documentRef.update({'id': documentId, 'userUid': userUid});

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Post created successfully'),
      //   ),

      // );

      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Consumer(
        builder: (_, WidgetRef ref, __) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _moderatorNameController,
                    decoration: InputDecoration(
                      labelText: 'Moderator Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _pictureController,
                    decoration: InputDecoration(
                      labelText: 'Picture URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      _createPost();
                      final helloWorld = await ref.watch(postFutureProvider);
                      ref.refresh(postFutureProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Create Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
