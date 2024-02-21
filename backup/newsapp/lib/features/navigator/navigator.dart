import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/features/NewPost/newPostScreen.dart';
import 'package:newsapp/features/auth/repo/authRepository.dart';
import 'package:newsapp/features/auth/repo/currentUserrepository.dart';
import 'package:newsapp/features/home/screen/homescreen.dart';
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

    userU = user;
    print(userU);
  }

  @override
  void initState() {
    getCurrentUserUid();
    // TODO: implement initState
    super.initState();
  }

  List<Widget> widgetList = [HomeScreen(), NewPostScreen(), SuperUser()];
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
                  body: IndexedStack(
                    children: widgetList,
                    index: myIndex,
                  ),
                  bottomNavigationBar: BottomNavigationBar(
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
                                icon: Icon(Icons.home), label: 'Home'),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.home), label: 'Home')
                          ]
                        : check.moderator == true
                            ? [
                                BottomNavigationBarItem(
                                    icon: Icon(Icons.home), label: 'Home'),
                                BottomNavigationBarItem(
                                    icon: Icon(Icons.home), label: 'Home'),
                                BottomNavigationBarItem(
                                    icon: Icon(Icons.home), label: 'Home')
                              ]
                            : [
                                BottomNavigationBarItem(
                                    icon: Icon(Icons.home), label: 'Home'),
                                BottomNavigationBarItem(
                                    icon: Icon(Icons.home), label: 'Home'),
                                // BottomNavigationBarItem(
                                //     icon: Icon(Icons.home), label: 'Home')
                              ],
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
