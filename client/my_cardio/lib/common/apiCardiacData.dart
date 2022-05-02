import 'package:http/http.dart' as http;

// TODO replace '1' with actual userId
// TODO replace BASE_URI after deploy

class CardiacDataApiMethods {
  static const String BASE_URI = 'http://10.0.2.2:3000';

  Future getData() async {
    try {
      final response =
          await http.get(Uri.parse('$BASE_URI/api/users/1/cardiacdata'));

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
