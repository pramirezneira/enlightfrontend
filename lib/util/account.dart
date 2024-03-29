import 'dart:convert';
import 'package:enlight/util/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Account {
  static Future<int> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/login",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "email": email,
          "password": password,
        },
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await Token.setAccessToken(data["access_token"]);
      await Token.setRefreshToken(data["refresh_token"]);
    }
    return response.statusCode;
  }

  static Future<bool> logout() async {
    final token = await Token.getRefreshToken();
    final response = await http.get(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/logout",
      ),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      await Token.deleteRefreshToken();
      return true;
    }
    return false;
  }

  static Future<int> signUp({
    required String email,
    required String password,
    required String name,
    required String birthDate,
    required String address,
    required String role,
  }) async {
    final response = await http.post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/account",
      ),
      headers: Map.from({"Content-Type": "application/json"}),
      body: json.encode(
        {
          "email": email,
          "password": password,
          "name": name,
          "birth_date": birthDate,
          "address": address,
          "role": role,
        },
      ),
    );
    return response.statusCode;
  }
}
