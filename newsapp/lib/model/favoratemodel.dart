class FavoriteModel {
  final String id;
  final String title;

  FavoriteModel({required this.id, required this.title});

  factory FavoriteModel.fromMap(Map<String, dynamic> data, String id) {
    return FavoriteModel(
      id: id,
      title: data['title'] ?? '',
    );
  }
}
