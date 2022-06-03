import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_cardio/common/sharedPreferences.dart';
import 'package:my_cardio/models/userProfileData.dart';
import 'package:my_cardio/models/userStatsSummary.dart';

import 'constants.dart';

class UserApiMethods {
  Future login(codigo, password) async {
    try {
      final response = await http.post(Uri.parse('$BASE_URI/api/users/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'codigo': codigo, 'password': password}));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = jsonDecode(response.body);
        final user = UserProfileData.fromJson(res);
        await MySharedPreferences.instance.setStringValue(
            "username", user.nome == null ? DEFULT_NAME : user.nome!);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error;
    }
  }

  Future getMedicalRecord(String code) async {
    if (code != 'initialize') {
      try {
        final response =
            await http.get(Uri.parse('$BASE_URI/api/users/$code/medrecord'));

        if (response.statusCode == 200) {
          Map<String, dynamic> res = jsonDecode(response.body);
          final user = UserProfileData.fromJson(res);
          return user;
        } else {
          throw Exception('Failed to load items');
        }
      } catch (e) {
        return e.toString();
      }
    }
  }

  Future getStatsSummary(String code) async {
    if (code != 'initialize') {
      try {
        final response =
            await http.get(Uri.parse('$BASE_URI/api/users/$code/stats'));

        if (response.statusCode == 200) {
          Map<String, dynamic> res = jsonDecode(response.body);
          final summary = UserStatsSummary.fromJson(res);
          return summary;
        } else {
          throw Exception('Failed to load items');
        }
      } catch (e) {
        return e.toString();
      }
    }
  }
}
