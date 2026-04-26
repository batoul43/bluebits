import 'dart:convert';

import 'package:bluebits_app/fetures/auth/data/models/userdata.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  final String baseUrl =
      'https://bluebits24.onrender.com/api/v1.0.0/users/signup';
  Future<dynamic> signup(UserData signupdata) async {
    try {
      final Response = await http.post(
        Uri.parse('${baseUrl}'),
        headers: {'Content-type': 'application/json;'},
        body: jsonEncode(signupdata.toJson()),
      );
      print(Response.statusCode);
      if (Response.statusCode == 200 || Response.statusCode == 201) {
        return jsonDecode(Response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
