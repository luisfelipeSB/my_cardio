import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../model/item.dart';

class ItemRepository {
  static const String BASE_URI = 'http://10.0.2.2:3000';

  Future getData() async {
    try {
      final response = await http.get(Uri.parse('$BASE_URI/api/users/1/checklist/items'));

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<Item> item = it.map((e) => Item.fromJson(e)).toList();
        return item;
      } else {
        throw Exception('Failed to load item');
      }
  
    } catch(e) {
      return e.toString();
    }
  }

  Future createData(String itemName) async {
      final response = await http.post(Uri.parse('$BASE_URI/api/checklist/additem'),
      headers: {
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'item_name' : itemName,
        'user_id_FK' : 1
      }),
      );

    try {
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      return e.toString();
    }

  }

  Future updateData(String id, String itemName) async {
    final response = await http.put(Uri.parse('$BASE_URI/api/checklist/item/$id/updatename'),
      headers: {
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'item_name' : itemName
      }),
      );

      try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      return e.toString();
    }

  }

  Future deleteData(String id) async {
    final response = await http.delete(Uri.parse('$BASE_URI/api/checklist/item/$id/delete'));

      try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      return e.toString();
    }

  }

  Future updateCheck(String id) async {
    final response = await http.put(Uri.parse('$BASE_URI/api/checklist/item/$id/updatecheck'));

      try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      return e.toString();
    }

  }




}
