import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constants.dart';

class CardiacDataApiMethods {
  Future getData(usercode) async {
    try {
      final response = await http
          .get(Uri.parse('$BASE_URI/api/users/$usercode/cardiacdata'));

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future getRiskData() async {
    try {
      final response =
          await http.get(Uri.parse('$BASE_URI/api/users/1/cardiacdata/risks'));

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
  }
}
