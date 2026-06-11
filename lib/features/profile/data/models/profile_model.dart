class ProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? photo;

  ProfileModel({this.id, this.name, this.email, this.photo});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // The API may wrap the user in a `data` field or return the object directly
    final user = json['data'] ?? json;
    return ProfileModel(
      id: user['_id']?.toString() ?? user['id']?.toString(),
      name: user['name']?.toString(),
      email: user['email']?.toString(),
      photo: user['photo']?.toString() ?? user['profile_image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photo': photo,
  };
}
