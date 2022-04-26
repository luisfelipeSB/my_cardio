import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../models/item.dart';

class ItemRepository {
  static const String BASE_URI = 'http://10.0.2.2:3000';
  List<Item> items = [
    Item(itemId: 1, itemName: 'Jog after work', itemCheck: false),
    Item(itemId: 2, itemName: 'Call parents', itemCheck: true),
    Item(itemId: 3, itemName: 'Organize workspace', itemCheck: false),
  ];

  Future getData() async {
    return items;
    /*
    try {
      final response =
          await http.get(Uri.parse('$BASE_URI/api/users/1/checklist/items'));

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<Item> items = it.map((e) => Item.fromJson(e)).toList();
        return items;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      return e.toString();
    }
    */
  }

  Future createData(String itemName) async {
    items.add(Item(itemId: items.length, itemName: itemName, itemCheck: false));
    return true;
    /*
    final response = await http.post(
      Uri.parse('$BASE_URI/api/checklist/additem'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'item_name': itemName, 'user_id_FK': 1}),
    );

    try {
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
    */
  }

  Future updateData(String id, String itemName) async {
    items[int.parse(id)].itemName = itemName;
    return true;
    /*
    final response = await http.put(
      Uri.parse('$BASE_URI/api/checklist/item/$id/updatename'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'item_name': itemName}),
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
    */
  }

  Future deleteData(String id) async {
    items.removeAt(int.parse(id));
    return true;
    /*
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
    */
  }

  Future updateCheck(String id) async {
    items[int.parse(id)].itemCheck = !items[int.parse(id)].itemCheck;
    return true;
    /*
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
    */
  }
}
