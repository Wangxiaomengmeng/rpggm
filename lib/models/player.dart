// 必须导入GameItem！
import 'item.dart';

class Player {
  String id;
  String name;
  int level; // 等级上限100级（超肝）
  int gold;
  int diamond;
  int exp;
  List<GameItem> backpack; // 背包

  Player({
    required this.id,
    this.name = "冒险者",
    this.level = 1,
    this.gold = 1000,
    this.diamond = 100,
    this.exp = 0,
    List<GameItem>? backpack,
  }) : backpack = backpack ?? [];

  // 转Firestore数据
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "level": level,
        "gold": gold,
        "diamond": diamond,
        "exp": exp,
        "backpack": backpack.map((e) => e.toMap()).toList(),
      };

  // 从Firestore创建
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map["id"],
      name: map["name"],
      level: map["level"],
      gold: map["gold"],
      diamond: map["diamond"],
      exp: map["exp"],
      backpack: (map["backpack"] as List).map((e) => GameItem.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }
}