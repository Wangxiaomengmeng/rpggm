import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/task.dart';
import '../services/firebase_service.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final tasks = provider.tasks;

    // 任务分类
    final mainTasks = tasks.where((t) => t.title.contains("主线")).toList();
    final branchTasks = tasks.where((t) => t.title.contains("支线")).toList();
    final dailyTasks = tasks.where((t) => t.isDaily).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("任务列表")),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "主线任务(20)"),
                Tab(text: "支线任务(30)"),
                Tab(text: "日常任务(20)"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTaskList(mainTasks, provider, context),
                  _buildTaskList(branchTasks, provider, context),
                  _buildTaskList(dailyTasks, provider, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建任务列表
  Widget _buildTaskList(List<GameTask> tasks, GameProvider provider, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        final task = tasks[i];
        return Card(
          color: task.isCompleted ? Colors.grey[200] : null,
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.desc),
            trailing: task.isCompleted
                ? const Text("已完成", style: TextStyle(color: Colors.green))
                : ElevatedButton(
                    onPressed: () {
                      // 标记任务完成 + 发放奖励
                      final updatedTask = GameTask(
                        id: task.id,
                        title: task.title,
                        desc: task.desc,
                        rewardGold: task.rewardGold,
                        rewardExp: task.rewardExp,
                        isCompleted: true,
                        isDaily: task.isDaily,
                      );
                      provider.tasks[i] = updatedTask;
                      // 发放奖励
                      provider.player.gold += task.rewardGold;
                      provider.player.exp += task.rewardExp;
                      // 同步到联机数据库
                      FirebaseService.savePlayer(provider.player);
                      // 提示
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("完成任务！获得${task.rewardGold}金币+${task.rewardExp}经验")),
                      );
                    },
                    child: const Text("完成"),
                  ),
          ),
        );
      },
    );
  }
}