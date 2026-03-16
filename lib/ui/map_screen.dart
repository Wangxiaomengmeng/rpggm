import 'package:flutter/material.dart';
// 5张大地图：森林、沙漠、地下城、天空城、魔界（半小时逛不完）
class MapScreen extends StatelessWidget {
  final List<Map<String, String>> maps = [
    {"name": "幽暗森林", "desc": "新手区域｜怪物Lv1-20"},
    {"name": "炽焰沙漠", "desc": "中级区域｜怪物Lv21-40"},
    {"name": "深渊地下城", "desc": "高级区域｜怪物Lv41-60"},
    {"name": "天空之城", "desc": "史诗区域｜怪物Lv61-80"},
    {"name": "魔界深渊", "desc": "终极区域｜怪物Lv81-100"},
  ];

  MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("世界地图")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: maps.length,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            title: Text(maps[i]["name"]!),
            subtitle: Text(maps[i]["desc"]!),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {}, // 进入地图战斗/探索
          ),
        ),
      ),
    );
  }
}