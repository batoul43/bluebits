import 'dart:convert';

import 'package:bluebits_app/features/auth/data/models/userdata.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  final String baseUrl = 'https://bluebits24.onrender.com/api/v1.0.0/users/';
  Future<dynamic> signup(UserData signupdata) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}signup'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(signupdata.toJson()),
      );
      print(response.statusCode);
      print('------------------------------------------');
      print(response.body);
      print('------------------------------------------');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> login(UserData logindata) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(logindata.toJson()),
      );
      print(response.statusCode);
      print('------------------------------------------');
      print(response.body);
      print('------------------------------------------');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> ForgetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}forgotPassword'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      print('------------------------------------------');
      print(response.body);
      print('------------------------------------------');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
