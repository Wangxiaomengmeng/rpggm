import 'package:flutter/material.dart';
import '../providers/game_provider.dart';
import '../services/redeem_service.dart';
import 'package:provider/provider.dart';

class RedeemDialog extends StatefulWidget {
  const RedeemDialog({super.key});

  @override
  State<RedeemDialog> createState() => _RedeemDialogState();
}

class _RedeemDialogState extends State<RedeemDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    return AlertDialog(
      title: const Text("兑换码"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _controller, decoration: const InputDecoration(hintText: "输入vip666/vip888")),
          const SizedBox(height: 10),
          // 管理员修改物品数量
          if (provider.isAdmin)
            ElevatedButton(
              onPressed: () => _showEditItemDialog(provider),
              child: const Text("🔧 修改物品数量"),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("取消")),
        ElevatedButton(
          onPressed: () {
            RedeemService.redeemCode(_controller.text.trim(), provider);
            Navigator.pop(context);
          },
          child: const Text("确认兑换"),
        ),
      ],
    );
  }

  // 管理员修改物品数量弹窗
  void _showEditItemDialog(GameProvider provider) {
    final idController = TextEditingController();
    final countController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("管理员修改物品"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: idController, decoration: const InputDecoration(hintText: "物品ID")),
            TextField(controller: countController, decoration: const InputDecoration(hintText: "数量"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              provider.editItemCount(idController.text, int.parse(countController.text));
              Navigator.pop(ctx);
            },
            child: const Text("确认修改"),
          ),
        ],
      ),
    );
  }
}