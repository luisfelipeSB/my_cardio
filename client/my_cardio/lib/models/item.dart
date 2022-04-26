class Item {
  final int itemId;
  String itemName;
  bool itemCheck;

  Item({
    required this.itemId,
    required this.itemName,
    required this.itemCheck,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'],
      itemName: json['item_name'],
      itemCheck: json['item_check'],
    );
  }
}
