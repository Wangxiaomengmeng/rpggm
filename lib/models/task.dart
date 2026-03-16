class GameTask {
  String id;
  String title;
  String desc;
  int rewardGold;
  int rewardExp;
  bool isCompleted;
  bool isDaily; // 日常任务（无限刷，超肝）

  GameTask({
    required this.id,
    required this.title,
    required this.desc,
    this.rewardGold = 100,
    this.rewardExp = 50,
    this.isCompleted = false,
    this.isDaily = false,
  });
}