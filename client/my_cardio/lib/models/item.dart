class Item {
  final int itemId;
  String itemName;
  // String itemTag;
  bool itemCheck;

  Item({
    required this.itemId,
    required this.itemName,
    // required this.itemTag,
    required this.itemCheck,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'],
      itemName: json['item_name'],
      // itemTag: json['item_tag'],
      itemCheck: json['item_check'],
    );
  }
}
