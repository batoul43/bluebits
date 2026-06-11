import 'dart:convert';

import 'package:http/http.dart' as http;

class ProfileApi {
  final String baseUrl = 'https://bluebits24.onrender.com/api/v1.0.0/users/';

  Future<dynamic> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}me'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('ProfileApi.getProfile: ${response.statusCode}');
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('ProfileApi.getProfile error: $e');
      return null;
    }
  }
}
