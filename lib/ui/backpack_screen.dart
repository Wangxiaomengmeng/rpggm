import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/firebase_service.dart';

class BackpackScreen extends StatefulWidget {
  const BackpackScreen({super.key});

  @override
  State<BackpackScreen> createState() => _BackpackScreenState();
}

class _BackpackScreenState extends State<BackpackScreen> {
  // 临时存储修改的数量（管理员功能）
  final Map<String, TextEditingController> _countControllers = {};

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final player = provider.player;

    // 为每个物品初始化控制器（管理员用）
    for (var item in player.backpack) {
      if (!_countControllers.containsKey(item.id)) {
        _countControllers[item.id] = TextEditingController(text: item.count.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("我的背包")),
      body: player.backpack.isEmpty
          ? const Center(child: Text("背包空空如也～输入vip666领取奖励吧！"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: player.backpack.length,
              itemBuilder: (ctx, i) {
                final item = player.backpack[i];
                final rarityColor = [
                  Colors.grey, // 1星
                  Colors.green, // 2星
                  Colors.blue, // 3星
                  Colors.purple, // 4星
                  Colors.orange, // 5星
                ][item.rarity - 1];

                return Card(
                  child: ListTile(
                    leading: Icon(
                      // 替换为Web端兼容的通用图标
                      item.type == "weapon" ? Icons.gavel :
                      item.type == "material" ? Icons.block :
                      Icons.local_pharmacy,
                      color: rarityColor,
                    ),
                    title: Text(item.name),
                    subtitle: Text("类型：${item.type} | 稀有度：${item.rarity}星"),
                    trailing: provider.isAdmin
                        ? // 管理员：可修改数量
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: _countControllers[item.id],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.save),
                                onPressed: () {
                                  final newCount = int.tryParse(_countControllers[item.id]!.text) ?? 1;
                                  provider.editItemCount(item.id, newCount);
                                  FirebaseService.savePlayer(player); // 同步到联机数据库
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${item.name}数量修改为$newCount")),
                                  );
                                },
                              ),
                            ],
                          )
                        : // 普通玩家：仅显示数量
                        Text("数量：${item.count}"),
                  ),
                );
              },
            ),
    );
  }
}