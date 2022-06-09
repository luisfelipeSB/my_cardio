import 'dart:convert';
import 'dart:developer';

import 'package:my_cardio/common/constants.dart';
import 'package:my_cardio/models/measurement.dart';
import 'package:my_cardio/models/measurement_flag.dart';

import 'package:http/http.dart' as http;

class CardiacDataApiMethods {
  Future getData(String code, List<int> datatypes) async {
    if (code != 'initialize' && datatypes.isNotEmpty) {
      List<List<Measurement>> measurements = [];
      for (int i = 0; i < datatypes.length; i++) {
        int datatype = datatypes[i];
        log('requesting datatype $datatype');
        try {
          final response = await http.get(
              Uri.parse('$BASE_URI/api/users/$code/cardiacdata/$datatype'));

          if (response.statusCode == 200) {
            Iterable it = jsonDecode(response.body)['rows'];
            List<Measurement> data =
                it.map((e) => Measurement.fromJson(e)).toList();
            measurements.add(data);
          }
        } catch (error) {
          log(error.toString());
          return error;
        }
      }
      return measurements;
    }
  }

  Future getRiskData(String code) async {
    if (code != 'initialize') {
      try {
        final response =
            await http.get(Uri.parse('$BASE_URI/api/users/$code/risks'));

        if (response.statusCode == 200) {
          Iterable it = jsonDecode(response.body);
          List<MeasurementFlag> risks =
              it.map((e) => MeasurementFlag.fromJson(e)).toList();
          return risks;
        } else {
          return List<MeasurementFlag>.empty();
        }
      } catch (error) {
        log(error.toString());
        return error;
      }
    }
    return List<MeasurementFlag>.empty();
  }
}
