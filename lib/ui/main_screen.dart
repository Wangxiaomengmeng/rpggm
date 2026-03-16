import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/firebase_service.dart';
import 'map_screen.dart';
import 'backpack_screen.dart';
import 'task_screen.dart';
import 'online_screen.dart';
import 'redeem_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 模拟玩家ID（实际项目可结合Firebase Auth获取真实UID）
  final String _playerUid = "player_001";

  @override
  void initState() {
    super.initState();
    // 初始化玩家数据 + 监听Firebase联机数据同步
    final provider = Provider.of<GameProvider>(context, listen: false);
    provider.initPlayer(_playerUid);
    // 实时同步Firebase中的玩家数据
    FirebaseService.streamPlayer(_playerUid).listen((player) {
      provider.syncPlayer(player);
    });
    // 首次初始化后保存数据到Firebase
    FirebaseService.savePlayer(provider.player);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final player = provider.player;

    return Scaffold(
      appBar: AppBar(
        title: const Text("超肝联机RPG"),
        actions: [
          // 兑换码按钮
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => const RedeemDialog(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 玩家信息卡片
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "角色：${player.name} (Lv.${player.level})",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("金币：${player.gold}"),
                        Text("钻石：${player.diamond}"),
                        Text("经验：${player.exp}/1000"),
                      ],
                    ),
                    // 升级按钮（测试用）
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        provider.levelUp();
                        FirebaseService.savePlayer(player); // 升级后同步到联机数据库
                      },
                      child: const Text("升级（测试）"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 功能入口网格
            const Text(
              "功能入口",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                // 地图入口（移除const！）
                _buildFunctionCard(
                  icon: Icons.map,
                  title: "世界地图",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => MapScreen()),
                  ),
                ),
                // 背包入口（移除const！）
                _buildFunctionCard(
                  icon: Icons.backpack,
                  title: "我的背包",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => BackpackScreen()),
                  ),
                ),
                // 任务入口（移除const！）
                _buildFunctionCard(
                  icon: Icons.task,
                  title: "任务列表",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => TaskScreen()),
                  ),
                ),
                // 联机大厅（移除const！）
                _buildFunctionCard(
                  icon: Icons.people,
                  title: "联机大厅",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => OnlineScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 封装功能卡片样式
  Widget _buildFunctionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}