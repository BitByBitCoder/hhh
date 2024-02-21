import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/features/auth/repo/currentUserrepository.dart';

class ProfileSreen extends StatefulWidget {
  const ProfileSreen({super.key});

  @override
  State<ProfileSreen> createState() => _ProfileSreenState();
}

class _ProfileSreenState extends State<ProfileSreen> {
  User? userU;

  void getCurrentUserUid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    userU = user;
    print(userU);
  }

  @override
  void initState() {
    getCurrentUserUid();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      // 2. specify the builder and obtain a WidgetRef
      builder: (_, WidgetRef ref, __) {
        // 3. use ref.watch() to get the value of the provider
        final profile = ref.watch(futureCurrentUserProvider(userU.toString()));
        return profile.when(
            data: (data) => Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/dfd.jpg'),
                        maxRadius: 100,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        '${data.name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(
                        '${data.email}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ],
                  ),
                ),
            error: (Error, StackTrace) => Text('errr'),
            loading: () => Text('loading'));
      },
    );
  }
}
