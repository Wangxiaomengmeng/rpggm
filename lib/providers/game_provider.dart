import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/item.dart';
import '../models/task.dart';

class GameProvider with ChangeNotifier {
  late Player player;
  List<GameTask> tasks = [];
  bool isAdmin = false; // 管理员权限（vip888激活）

  // 初始化玩家
  void initPlayer(String uid) {
    player = Player(id: uid);
    initTasks();
    notifyListeners();
  }

  // 初始化70+任务（超肝）
  void initTasks() {
    tasks = List.generate(70, (index) => GameTask(
      id: "task$index",
      title: index < 20 ? "主线任务 $index" : index < 50 ? "支线任务 $index" : "日常任务 $index",
      desc: "完成挑战获得奖励",
      isDaily: index >= 50,
    ));
  }

  // 添加物品到背包（修复类型推断）
  void addItem(GameItem item) {
    // 显式指定GameItem类型，解决Object?无id问题
    int index = player.backpack.indexWhere((GameItem e) => e.id == item.id);
    if (index != -1) {
      player.backpack[index].count += item.count;
    } else {
      player.backpack.add(item);
    }
    notifyListeners();
  }

  // 管理员：修改物品数量（修复类型推断）
  void editItemCount(String itemId, int count) {
    int index = player.backpack.indexWhere((GameItem e) => e.id == itemId);
    if (index != -1) {
      player.backpack[index].count = count;
    }
    notifyListeners();
  }

  // 升级
  void levelUp() {
    player.level++;
    notifyListeners();
  }

  // 同步玩家数据到状态
  void syncPlayer(Player newPlayer) {
    player = newPlayer;
    notifyListeners();
  }
}