import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 保存玩家数据
  static Future<void> savePlayer(Player player) async {
    await _db.collection("players").doc(player.id).set(player.toMap());
  }

  // 实时监听玩家数据（联机同步）
  static Stream<Player> streamPlayer(String uid) {
    return _db.collection("players").doc(uid).snapshots().map(
          (snap) => Player.fromMap(snap.data() as Map<String, dynamic>),
        );
  }
}