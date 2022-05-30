import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_cardio/models/userProfileData.dart';

import 'constants.dart';
import 'sharedPreferences.dart';

class UserApiMethods {
  Future login(codigo, password) async {
    try {
      final response = await http.post(Uri.parse('$BASE_URI/api/users/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'codigo': codigo, 'password': password}));

      if (response.statusCode == 200) {
        /*
        Map<String, dynamic> res = jsonDecode(response.body);
        await MySharedPreferences.instance
            .setStringValue('user', jsonEncode(res).toString());
        */
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error;
    }
  }

  Future getProfileData(String code) async {
    if (code != 'initialize') {
      try {
        final response = await http.get(Uri.parse('$BASE_URI/api/users/$code'));

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
}
