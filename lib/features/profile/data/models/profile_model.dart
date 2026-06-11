class ProfileModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  Data? data;

  ProfileModel({this.isSuccess, this.message, this.statusCode, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? email;
  String? role;
  String? profileImage;
  bool? isVerified;
  bool? isBanned;
  String? createdAt;
  String? updatedAt;

  Data({
    this.sId,
    this.name,
    this.email,
    this.role,
    this.profileImage,
    this.isVerified,
    this.isBanned,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    profileImage = json['profile_image'];
    isVerified = json['isVerified'];
    isBanned = json['isBanned'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['profile_image'] = profileImage;
    data['isVerified'] = isVerified;
    data['isBanned'] = isBanned;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
