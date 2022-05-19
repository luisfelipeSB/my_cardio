class ChecklistItem {
  final int itemId;
  String itemName;
  String itemTag;
  bool itemCheck;

  ChecklistItem({
    required this.itemId,
    required this.itemName,
    required this.itemTag,
    required this.itemCheck,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      itemId: json['item_id'],
      itemName: json['item_name'],
      itemTag: json['item_category'],
      itemCheck: json['item_check'],
    );
  }
}
