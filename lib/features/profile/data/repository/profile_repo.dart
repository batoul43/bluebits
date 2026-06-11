import 'package:bluebits_app/features/profile/data/api_service/profile_api.dart';
import 'package:bluebits_app/features/profile/data/models/profile_model.dart';

class ProfileRepo {
  final ProfileApi profileApi;
  ProfileRepo({required this.profileApi});

  Future<ProfileModel?> getProfile(String token) async {
    final res = await profileApi.getProfile(token);
    if (res == null) return null;
    try {
      // res is expected to be a decoded JSON (Map)
      final Map<String, dynamic> map = Map<String, dynamic>.from(res);
      final userJson = map['data'] ?? map;
      return ProfileModel.fromJson(userJson);
    } catch (e) {
      print('ProfileRepo.getProfile parsing error: $e');
      return null;
    }
  }
}
