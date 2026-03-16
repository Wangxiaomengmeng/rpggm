import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class OnlineScreen extends StatelessWidget {
  const OnlineScreen({super.key});

  // 获取所有在线玩家
  Stream<List<Player>> _getOnlinePlayers() {
    return FirebaseFirestore.instance
        .collection("players")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Player.fromMap(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("联机大厅")),
      body: StreamBuilder<List<Player>>(
        stream: _getOnlinePlayers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("加载失败：${snapshot.error}"));
          }
          final players = snapshot.data ?? [];
          if (players.isEmpty) {
            return const Center(child: Text("暂无在线玩家～"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length,
            itemBuilder: (ctx, i) {
              final player = players[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person, size: 40),
                  title: Text("${player.name} (Lv.${player.level})"),
                  subtitle: Text("金币：${player.gold} | 钻石：${player.diamond}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("已邀请${player.name}组队！")),
                      );
                    },
                    child: const Text("组队"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}