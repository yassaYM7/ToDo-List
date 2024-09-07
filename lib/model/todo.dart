class ToDo {
  String? id;
  String? todoText;
  DateTime? time;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.time,
    this.isDone = false,
  });

  ToDo copyWith({
    String? id,
    String? todoText,
    DateTime? time,
    bool? isDone,
  }) {
    return ToDo(
      id: id ?? this.id,
      todoText: todoText ?? this.todoText,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
    );
  }

  static List<ToDo> todoList() {
    return [];
  }
}
