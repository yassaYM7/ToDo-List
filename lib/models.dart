

class Task {
  String id;
  List<TaskItem> items;
  String time;
  bool isExpanded;

  Task(this.id, this.items, this.time, {this.isExpanded = false});
}

class TaskItem {
  String text;
  bool isCompleted;
  DateTime? time; 

  TaskItem(this.text, {this.isCompleted = false, this.time});
}
