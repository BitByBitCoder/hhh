import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String name;
  final String email;
  final String uid;
  final bool superUser;
  final bool moderator;
  final Timestamp createdAt;

  CurrentUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.superUser,
    required this.moderator,
    required this.createdAt,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      uid: json['uid'] ?? '',
      superUser: json['superUser'] ?? false,
      moderator: json['moderator'] ?? false,
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }
}
