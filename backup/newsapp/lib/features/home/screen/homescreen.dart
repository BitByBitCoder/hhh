import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/features/NewPost/newPostScreen.dart';
import 'package:newsapp/features/home/repository/post.dart';
import 'package:newsapp/features/superUser/superUserScreen.dart';

// 1. extend [ConsumerStatefulWidget]
class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

// 2. extend [ConsumerState]
class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    // 4. use ref.watch() to get the value of the provider

    void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ref.refresh(postFutureProvider);
      });

      // "Hello world"
    }

    Future<bool> checkIfUserLiked(String postId, String userId) async {
      final likeRef = FirebaseFirestore.instance
          .collection('Post')
          .doc(postId)
          .collection('likes')
          .doc(userId);

      final likeDoc = await likeRef.get();
      return likeDoc.exists;
    }

    final postModelListAsync = ref.watch(postFutureProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SuperUser()));
              },
              icon: Icon(Icons.supervised_user_circle)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.purple,
              ))
        ],
        title: Text('Post List'),
      ),
      body: postModelListAsync.when(
        data: (postList) {
          if (postList.isEmpty) {
            return Center(
              child: Text('No posts found'),
            );
          }
          return ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
              final post = postList[index];
              final useruid = FirebaseAuth.instance.currentUser?.uid;
              checkIfUserLiked(postList[index].id, useruid!);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.black)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1,
                      ),
                      Container(
                        width: double.infinity, // Container width
                        height: 200,
                        child: Image.asset(
                          'assets/images/dfd.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Editor:${postList[index].moderatorName}'),
                            Text('${postList[index].title}'),
                            Text(
                              "sdfsdfsdfsdfassdflkjsadklfjaklsdfklsadjfkladlskfjklasdjflkdjssjdfkljsdklfjklsdafjklsdajfkldjsalkfjsadkljfldksaj",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final useruid = await FirebaseAuth
                                    .instance.currentUser?.uid;

                                setState(() {});
                              },
                              icon: Icon(Icons.favorite_border),
                            ),
                            TextButton(onPressed: () {}, child: Text('comment'))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
              // ListTile(
              //   title: Text(post.title),
              //   subtitle: Text(post.moderatorName),
              //   trailing: Text(post.createdAt.toDate().toString()),
              // );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewPostScreen()));
        },
        child: Icon(Icons.plus_one),
      ),
    );
  }
}
