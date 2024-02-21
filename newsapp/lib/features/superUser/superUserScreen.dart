import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/features/auth/repo/authRepository.dart';
import 'package:newsapp/features/superUser/moderatorstate.dart';
import 'package:newsapp/model/usermodel.dart';

// class SuperUser extends StatefulWidget {
//   const SuperUser({Key? key}) : super(key: key);

//   @override
//   _SuperUserState createState() => _SuperUserState();
// }

// class _SuperUserState extends State<SuperUser> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, _) {
//       final userModelListAsync = ref.watch(userModelListProvider);
//       final setmoderator = ref.read(setUserRoleProvider);
//       final modswitch = ref.watch(moderatorStateProvider);

//       final newObj = modswitch;
//       initState() {
//         super.initState();
//       }

//       return Scaffold(
//         appBar: AppBar(
//           title: Text('User List'),
//         ),
//         body: userModelListAsync.when(
//           data: (userList) {
//             if (userList.isEmpty) {
//               return Center(
//                 child: Text('No users found'),
//               );
//             }
//             return Column(
//               children: [
//                 TextField(
//                   decoration: InputDecoration(
//                       label: Text('search'), suffix: Icon(Icons.search)),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: userList.length,
//                     itemBuilder: (context, index) {
//                       final user = userList[index];
//                       return ListTile(
//                           title: Text(user.name),
//                           subtitle: Text(user.email),
//                           trailing: IconButton(
//                             icon: user.moderator
//                                 ? Icon(
//                                     Icons.toggle_on,
//                                     color: Colors.purple,
//                                   )
//                                 : Icon(Icons.toggle_off),
//                             onPressed: () async {
//                               bool togglem = !user.moderator;
//                               print(togglem);
//                               print(user.uid);
//                               await setmoderator.setUserRole(user.uid, togglem);

//                               await ref.refresh(userModelListProvider);

//                               setState(() {});

//                               // ref.read(userModelListProvider);
//                             },
//                           ));
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//           error: (error, stackTrace) {
//             return Center(
//               child: Text('Error: $error'),
//             );
//           },
//           loading: () {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         ),
//       );
//     });
//   }
// }
class SuperUser extends StatefulWidget {
  const SuperUser({Key? key}) : super(key: key);

  @override
  _SuperUserState createState() => _SuperUserState();
}

class _SuperUserState extends State<SuperUser> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final userModelListAsync = ref.watch(userModelListProvider);
      final setmoderator = ref.read(setUserRoleProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text('User List'),
        ),
        body: userModelListAsync.when(
          data: (userList) {
            List<UserModel> filteredList = userList
                .where((user) =>
                    user.name
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    user.email
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                .toList();

            if (filteredList.isEmpty) {
              return Center(
                child: Text('No users found'),
              );
            }

            return Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(
                        () {}); // Trigger a rebuild to update the search results
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final user = filteredList[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        trailing: IconButton(
                          icon: user.moderator
                              ? Icon(
                                  Icons.toggle_on,
                                  color: Colors.purple,
                                )
                              : Icon(Icons.toggle_off),
                          onPressed: () async {
                            bool togglem = !user.moderator;
                            print(togglem);
                            print(user.uid);
                            await setmoderator.setUserRole(user.uid, togglem);

                            await ref.refresh(userModelListProvider);

                            setState(() {});

                            // ref.read(userModelListProvider);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
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
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
