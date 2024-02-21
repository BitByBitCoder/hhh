import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String title;
  final String moderatorName;
  final String moderatorUid;
  final String description;
  final String picture;
  final Timestamp createdAt;

  PostModel({
    required this.id,
    required this.title,
    required this.moderatorName,
    required this.moderatorUid,
    required this.description,
    required this.picture,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> data, String id) {
    return PostModel(
      id: id,
      title: data['title'] ?? '',
      moderatorName: data['moderatorName'] ?? '',
      moderatorUid: data['moderatorUid'] ?? '',
      description: data['description'] ?? '',
      picture: data['picture'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
