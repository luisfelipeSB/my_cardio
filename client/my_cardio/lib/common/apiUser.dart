import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_cardio/common/sharedPreferences.dart';
import 'package:my_cardio/models/notification.dart';
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

  Future getNotifications(String code) async {
    if (code != 'initialize') {
      try {
        final response = await http
            .get(Uri.parse('$BASE_URI/api/users/$code/notifications'));

        // Deserializing here to avoid having to add a field for each json;
        // client-side processing unburdens server performance
        if (response.statusCode == 200) {
          Iterable it1 = jsonDecode(response.body)['measurementsPerDOY'];
          Iterable it2 = jsonDecode(response.body)['risksPerDOY'];

          List<Notificationo> measurementsPerDOY = [];
          List<Notificationo> risksPerDOY = [];

          // Converting day of year to date and building Notifications
          final millisInADay =
              const Duration(days: 1).inMilliseconds; // 86400000

          for (final e in it1) {
            final int millisDayOfYear = e['day_of_year'] * millisInADay;
            final int millisecondsSinceEpoch =
                DateTime(DateTime.now().year).millisecondsSinceEpoch;
            final dayOfYearDate = DateTime.fromMillisecondsSinceEpoch(
                millisecondsSinceEpoch + millisDayOfYear);

            // DEMO ONLY (to show date from 2020)
            final date = dayOfYearDate.subtract(const Duration(days: 732));

            measurementsPerDOY.add(Notificationo(
                type: 'measur', day: date, occurrences: int.parse(e['count'])));
          }
          for (final e in it2) {
            final int millisDayOfYear = e['day_of_year'] * millisInADay;
            final int millisecondsSinceEpoch =
                DateTime(DateTime.now().year).millisecondsSinceEpoch;
            final dayOfYearDate = DateTime.fromMillisecondsSinceEpoch(
                millisecondsSinceEpoch + millisDayOfYear);

            // DEMO ONLY (to show date from 2020)
            final date = dayOfYearDate.subtract(const Duration(days: 732));

            risksPerDOY.add(Notificationo(
                type: 'risk', day: date, occurrences: int.parse(e['count'])));
          }

          // Combining notifications into a single list, sorted by item date
          List<List<Notificationo>> tmp = [];
          tmp.add(measurementsPerDOY);
          tmp.add(risksPerDOY);
          List<Notificationo> notifications = tmp.expand((i) => i).toList();

          return notifications;
        } else {
          return List<Notificationo>.empty();
        }
      } catch (error) {
        log(error.toString());
        return error;
      }
    }
    return List<Notificationo>.empty();
  }
}
