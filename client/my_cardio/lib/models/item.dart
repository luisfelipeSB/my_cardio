class Item {
  final int itemId;
  String itemName;
<<<<<<< HEAD:client/my_cardio/lib/models/item.dart
  String itemTag;
=======
  // String itemTag;
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d:client/lib/model/item.dart
  bool itemCheck;

  Item({
    required this.itemId,
    required this.itemName,
<<<<<<< HEAD:client/my_cardio/lib/models/item.dart
    required this.itemTag,
=======
    // required this.itemTag,
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d:client/lib/model/item.dart
    required this.itemCheck,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'],
      itemName: json['item_name'],
<<<<<<< HEAD:client/my_cardio/lib/models/item.dart
      itemTag: json['item_category'],
=======
      // itemTag: json['item_tag'],
>>>>>>> 89668093c0bf086f25b4c438b461f14915e6e73d:client/lib/model/item.dart
      itemCheck: json['item_check'],
    );
  }
}
