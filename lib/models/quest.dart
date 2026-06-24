/// 오늘의 퀘스트 아이템.
class Quest {
  final String id;
  final String title;
  final String description;
  final int current;
  final int total;
  final bool isCompleted;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    this.current = 0,
    this.total = 1,
    this.isCompleted = false,
  });
}
