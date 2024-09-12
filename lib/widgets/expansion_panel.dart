import 'package:flutter/material.dart';
import '../models/panel_model.dart';
import '../controllers/task_controller.dart';

class ExpansionPanelItem extends StatefulWidget {
  final PanelModel panel;
  final Function(TaskItem task) onDeleteTask;

  const ExpansionPanelItem({
    super.key,
    required this.panel,
    required this.onDeleteTask,
  });

  @override
  _ExpansionPanelItemState createState() => _ExpansionPanelItemState();
}

class _ExpansionPanelItemState extends State<ExpansionPanelItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: Container(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.blue, width: 3),
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: ExpansionPanelList(
            dividerColor: Colors.blue,
            expandedHeaderPadding: const EdgeInsets.all(2),
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                widget.panel.isExpanded = isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                backgroundColor: const Color.fromARGB(220, 255, 255, 255),
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  int completedTasks =
                      widget.panel.items.where((task) => task.isDone).length;
                  int totalTasks = widget.panel.items.length;

                  return ListTile(
                    contentPadding:
                        const EdgeInsets.only(top: 18, bottom: 18, left: 2),
                    title: Text(
                      widget.panel.time,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: completedTasks == totalTasks
                            ? Colors.green
                            : completedTasks == 0
                                ? Colors.grey
                                : Colors.orange,
                      ),
                      completedTasks == totalTasks
                          ? "Completed"
                          : "$completedTasks/$totalTasks Tasks Completed",
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: widget.panel.items.map((task) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(color: Colors.black, width: 2),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          title: Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 20,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          leading: Checkbox(
                            value: task.isDone,
                            checkColor: Color.fromARGB(255, 247, 248, 247),
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                task.isDone = value!;
                              });
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showEditDialog(task);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 25,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  _deleteTask(task);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                isExpanded: widget.panel.isExpanded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTask(TaskItem task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Task",
            style: TextStyle(
                fontSize: 26, color: Color.fromARGB(255, 221, 11, 11)),
          ),
          content: const Text(
            "Are you sure you want to delete this task?!",
            style:
                TextStyle(fontSize: 16, color: Color.fromARGB(172, 11, 10, 10)),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _roundedButton(
                  color: Colors.grey,
                  text: "Cancel",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                _roundedButton(
                  color: Colors.black,
                  text: "Delete",
                  onPressed: () {
                    widget.onDeleteTask(task);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _roundedButton(
      {required Color color,
      required String text,
      required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _circularButton(
      {required Color color,
      required String text,
      required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _showEditDialog(TaskItem task) {
    final TextEditingController editingController =
        TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Task",
            style: TextStyle(
                fontSize: 26, color: Color.fromARGB(255, 221, 11, 11)),
          ),
          content: TextField(
            style: const TextStyle(fontSize: 20),
            controller: editingController,
            decoration: const InputDecoration(
              hintText: "Edit this task",
              hintStyle:
                  TextStyle(fontSize: 14, color: Color.fromARGB(95, 0, 0, 0)),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _customButton(
                  color: Colors.grey,
                  text: "Cancel",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                _customButton(
                  color: Colors.orange,
                  text: "Update",
                  onPressed: () {
                    if (editingController.text.isNotEmpty) {
                      setState(() {
                        TaskController.editTask(task, editingController.text);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _customButton(
      {required Color color,
      required String text,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
