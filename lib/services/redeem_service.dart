import '../providers/game_provider.dart';
import '../models/item.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RedeemService {
  // 处理兑换码
  static void redeemCode(String code, GameProvider provider) {
    switch (code) {
      case "vip666":
        _giveVip666Reward(provider);
        break;
      case "vip888":
        _activateAdmin(provider);
        break;
      default:
        Fluttertoast.showToast(msg: "无效兑换码");
    }
  }

  // vip666：巨量奖励
  static void _giveVip666Reward(GameProvider provider) {
    provider.player.gold += 1000000; // 100万金币
    provider.player.diamond += 100000; // 10万钻石

    // 发放高级物品
    provider.addItem(GameItem(id: "sword", name: "神器·破晓", type: "weapon", count: 10, rarity: 5));
    provider.addItem(GameItem(id: "material", name: "强化石", type: "material", count: 9999, rarity: 4));
    provider.addItem(GameItem(id: "potion", name: "超级药水", type: "consumable", count: 999, rarity: 3));

    Fluttertoast.showToast(msg: "✅ vip666兑换成功！获得巨量奖励");
  }

  // vip888：激活管理员权限（修改物品数量）
  static void _activateAdmin(GameProvider provider) {
    provider.isAdmin = true;
    Fluttertoast.showToast(msg: "🔱 管理员权限激活！可修改物品数量");
  }
}