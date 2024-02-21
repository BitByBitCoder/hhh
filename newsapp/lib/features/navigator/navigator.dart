import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/features/NewPost/newPostScreen.dart';

import 'package:newsapp/features/auth/repo/currentUserrepository.dart';
import 'package:newsapp/features/home/screen/homescreen.dart';
import 'package:newsapp/features/profile/profileScreen.dart';
import 'package:newsapp/features/superUser/superUserScreen.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({super.key});

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  User? userU;

  void getCurrentUserUid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    var a = 1;
    userU = user;
    print('sdfsadfsd');
  }

  @override
  void initState() {
    getCurrentUserUid();
    // TODO: implement initState
    super.initState();
  }

  List<Widget> widgetList = [
    HomeScreen(),
    ProfileSreen(),
    SuperUser(),
  ];
  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      // 2. specify the builder and obtain a WidgetRef
      builder: (_, WidgetRef ref, __) {
        // 3. use ref.watch() to get the value of the provider
        final chekmoderator =
            ref.watch(futureCurrentUserProvider(userU.toString()));
        return chekmoderator.when(
            data: (check) => Scaffold(
                  appBar: AppBar(
                    actions: [
                      check.moderator == true
                          ? IconButton(
                              onPressed: () {
                                // Handle button press
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewPostScreen()));
                              },
                              icon: Icon(Icons.add),
                            )
                          : SizedBox
                              .shrink(), // Use SizedBox.shrink() to create an empty widget
                    ],
                  ),
                  body: IndexedStack(
                    children: widgetList,
                    index: myIndex,
                  ),
                  bottomNavigationBar: Container(
                    height: 100,
                    child: BottomNavigationBar(
                      onTap: (index) {
                        setState(() {
                          myIndex = index;
                        });
                      },
                      currentIndex: myIndex,
                      items: check.superUser == true
                          ? [
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.home), label: 'Home'),
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.account_box), label: 'Home'),
                              BottomNavigationBarItem(
                                  icon: Icon(Icons.admin_panel_settings),
                                  label: 'Profile'),
                            ]
                          : check.moderator == true
                              ? [
                                  BottomNavigationBarItem(
                                      icon: Icon(Icons.home), label: 'Home'),
                                  BottomNavigationBarItem(
                                      icon: Icon(Icons.account_box_outlined),
                                      label: 'Profile'),
                                ]
                              : [
                                  BottomNavigationBarItem(
                                      icon: Icon(Icons.home), label: 'Home'),
                                  BottomNavigationBarItem(
                                      icon: Icon(Icons.account_box_outlined),
                                      label: 'Profile'),

                                  // BottomNavigationBarItem(
                                  //     icon: Icon(Icons.home), label: 'p')
                                ],
                    ),
                  ),
                ),
            error: (error, StackTrace) {
              print('$error,$StackTrace');
              return Text('$error,$StackTrace');
            },
            loading: () => Text('loading'));
      },
    );
  }
}
