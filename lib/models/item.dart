class GameItem {
  String id;
  String name;
  String type; // weapon/material/consumable
  int count;
  int rarity; // 1-5星

  GameItem({
    required this.id,
    required this.name,
    required this.type,
    this.count = 1,
    this.rarity = 1,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "type": type,
        "count": count,
        "rarity": rarity,
      };

  factory GameItem.fromMap(Map<String, dynamic> map) => GameItem(
        id: map["id"],
        name: map["name"],
        type: map["type"],
        count: map["count"],
        rarity: map["rarity"],
      );
}