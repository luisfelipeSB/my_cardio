import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/item.dart';

// TODO replace '1' with actual userId
// TODO replace BASE_URI after deploy
// TODO edit item model

class checklistApiMethods {
  static const String BASE_URI = 'http://10.0.2.2:3000';

  /* Test
  List<Item> items = [
    Item(itemId: 1, itemName: 'Jog after work', itemCheck: false),
    Item(itemId: 2, itemName: 'Call family', itemCheck: true),
    Item(itemId: 3, itemName: 'Organize workspace', itemCheck: false),
  ];
  */

  Future getData() async {
    /*
    print('get ${items.length}');
    return items;
    */
    ///*
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
    //*/
  }

  Future createData(String itemName) async {
    /*
    items.add(
        Item(itemId: items.length + 1, itemName: itemName, itemCheck: false));
    print('create ${items.length}');
    return true;
    */
    ///*
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
    //*/
  }

  Future updateData(String id, String itemName) async {
    /*
    items.where((i) => i.itemId == int.parse(id)).toList()[0].itemName =
        itemName;
    print('update $id - #items: ${items.length}');
    return true;
    */
    ///*
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
    //*/
  }

  Future deleteData(String id) async {
    /*
    for (int i = 0; i < items.length; i++) {
      if (items[i].itemId == int.parse(id)) items.removeAt(i);
    }
    print('delete ${items.length}');
    return true;
    */
    ///*
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
    //*/
  }

  Future updateCheck(String id) async {
    /*
    var b = items.where((i) => i.itemId == int.parse(id)).toList()[0].itemCheck;
    items.where((i) => i.itemId == int.parse(id)).toList()[0].itemCheck = !b;
    print('bool ${!b}');
    return true;
    */
    ///*
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
    //*/
  }
}
