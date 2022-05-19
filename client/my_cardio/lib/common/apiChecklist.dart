import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'constants.dart';
import '../models/item.dart';

class ChecklistApiMethods {
  Future getData(usercode) async {
    try {
      if (usercode != "initialize") {
        final response = await http
            .get(Uri.parse('$BASE_URI/api/users/$usercode/checklist/items'));
        if (response.statusCode == 200) {
          Iterable it = jsonDecode(response.body);
          List<ChecklistItem> items =
              it.map((e) => ChecklistItem.fromJson(e)).toList();
          return items;
        } else if (response.statusCode == 404) {
          return List<ChecklistItem>.empty();
        }
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      List<ChecklistItem> initialize = [];
      return initialize;
    }
  }

  Future createData(
      String itemName, String selectedTag, String usercode) async {
    final response = await http.post(
      Uri.parse('$BASE_URI/api/checklist/additem'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'item_name': itemName,
        'item_category': selectedTag,
        'user_id_FK': usercode
      }),
    );

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future updateData(String id, String itemName, String selectedTag) async {
    final response = await http.put(
      Uri.parse('$BASE_URI/api/checklist/item/$id/updatename'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'item_name': itemName, 'item_category': selectedTag}),
    );

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteData(String id) async {
    final response =
        await http.delete(Uri.parse('$BASE_URI/api/checklist/item/$id/delete'));

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future updateCheck(String id) async {
    final response = await http
        .put(Uri.parse('$BASE_URI/api/checklist/item/$id/updatecheck'));

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
