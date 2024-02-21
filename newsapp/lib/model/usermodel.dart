import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String uid;
  final bool superUser;
  final bool moderator;
  final Timestamp createdAt;

  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.superUser,
    required this.moderator,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      uid: id,
      superUser: data['superUser'] ?? false,
      moderator: data['moderator'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
