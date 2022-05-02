import 'dart:convert';
<<<<<<< HEAD
import 'dart:developer';
=======
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d

import 'package:http/http.dart' as http;

import '../models/user.dart';

// TODO replace '1' with actual userId
// TODO replace BASE_URI after deploy - OR ADD IT TO A CONSTANTS FILE

class UserApiMethods {
  static const String BASE_URI = 'http://10.0.2.2:3000';

<<<<<<< HEAD
  Future login(code,password) async {
    try {
      final response = await http.post(Uri.parse('$BASE_URI/api/users/login'),
        headers: {
          'Content-Type': 'application/json',
          },
          body: jsonEncode({'codigo': code, 'password': password}));

      if (response.statusCode == 200) {
        /*Iterable it = jsonDecode(response.body);
        final User user = it.map((e) => User.fromJson(e)) as User;
        return user;*/
        return true;
      } else {
        return false;
=======
  Future login(user) async {
    return User(code: 123, sex: 'M', birthDate: DateTime(2019, 09, 09));
    try {
      final response = await http.post(Uri.parse('$BASE_URI/api/users/login'),
          body: jsonEncode({'code': user.code, 'password': user.password}));

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        final User user = it.map((e) => User.fromJson(e)) as User;
        return user;
      } else {
        throw Exception('Failed to load user');
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
      }
    } catch (e) {
      return e;
    }
  }

<<<<<<< HEAD
  /*Future getData() async {
=======
  Future getData() async {
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
    try {
      final response = await http.get(Uri.parse('$BASE_URI/api/users/1'));

      if (response.statusCode == 200) {
        //Iterable it = jsonDecode(response.body);
        final data = Object();
        return data;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      return e.toString();
    }
<<<<<<< HEAD
  }*/


=======
  }
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d
}
