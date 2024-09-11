class PanelModel {
  List<TaskItem> items;
  String time;
  bool? isCompleted;
  bool isExpanded;

  PanelModel({
    required this.items,
    required this.time,
    this.isCompleted,
    required this.isExpanded,
  });
}

class TaskItem {
  String description;
  bool isDone;

  TaskItem({required this.description, required this.isDone});
}
