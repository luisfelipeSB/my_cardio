import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_cardio/models/measurement.dart';

import 'constants.dart';

class CardiacDataApiMethods {
  Future getData(String code, List<int> datatypes) async {
    log(code);
    log(datatypes.toString());
    if (code != 'initialize' && datatypes.isNotEmpty) {
      List<List<Measurement>> measurements = [];
      for (int i = 0; i < datatypes.length; i++) {
        int datatype = datatypes[i];
        log('requesting $datatype');
        try {
          final response = await http.get(
              Uri.parse('$BASE_URI/api/users/$code/cardiacdata/$datatype'));

          if (response.statusCode == 200) {
            Iterable it = jsonDecode(response.body)['rows'];
            List<Measurement> data =
                it.map((e) => Measurement.fromJson(e)).toList();
            measurements.add(data);
          } else {
            measurements.add(List<Measurement>.empty());
          }
        } catch (error) {
          log(error.toString());
          return error;
        }
      }
      return measurements;
    }
    return List<List<Measurement>>.empty();
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
