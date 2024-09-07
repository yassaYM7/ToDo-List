import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final void Function(ToDo) onToDoChanged;
  final void Function(String) onDeleteItem;
  final void Function(ToDo) onEditItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.onEditItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2), 
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), 
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(4), 
        border: Border.all(color: Colors.orange, width: 1), 
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), 
            blurRadius: 1.0, 
            spreadRadius: 0.5, 
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: todo.isDone,
            onChanged: (value) {
              onToDoChanged(todo);
            },
          ),
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                todo.todoText!,
                style: TextStyle(
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  fontSize: 14, 
                ),
              ),
              subtitle: todo.time != null
                  ? Text(
                      'Due: ${DateFormat.yMMMd().format(todo.time!)} at ${DateFormat.jm().format(todo.time!)}',
                      style: const TextStyle(color: Colors.black, fontSize: 12), 
                    )
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange, size: 20), 
                    onPressed: () {
                      onEditItem(todo);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.orange, size: 20), 
                    onPressed: () {
                      if (todo.id != null) {
                        onDeleteItem(todo.id!);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
