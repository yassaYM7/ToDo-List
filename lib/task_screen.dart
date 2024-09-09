import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<Task> tasks = [];
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('EEE, dd MMMM yyyy').format(DateTime.now());

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddTaskBottomSheet(
          onTaskAdded: (newTasks) {
            setState(() {
              List<TaskItem> combinedTasks =
                  newTasks.where((task) => task.text.isNotEmpty).toList();
              if (combinedTasks.isNotEmpty) {
                tasks.add(Task(
                  DateTime.now().toString(),
                  combinedTasks,
                  DateFormat.jm().format(DateTime.now()),
                ));
              }
            });
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        formattedDate = DateFormat('EEE, dd MMMM yyyy').format(selectedDate);
      });
    }
  }

  int _countCheckedTasks(Task task) {
    return task.items.where((item) => item.isCompleted).length;
  }

  Color _getTaskStatusColor(Task task) {
    int completedTasks = _countCheckedTasks(task);
    if (completedTasks == 0) {
      return Colors.grey;
    } else if (completedTasks == task.items.length) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }

  String _getTaskStatusText(Task task) {
    int completedTasks = _countCheckedTasks(task);
    int totalTasks = task.items.length;
    if (completedTasks == totalTasks && totalTasks > 0) {
      return 'Completed';
    } else {
      return '$completedTasks/$totalTasks task completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.grey),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, taskIndex) {
                return TaskListTile(
                  task: tasks[taskIndex],
                  onDelete: (itemIndex) {
                    setState(() {
                      tasks[taskIndex].items.removeAt(itemIndex);
                      if (tasks[taskIndex].items.isEmpty) {
                        tasks.removeAt(taskIndex);
                      }
                    });
                  },
                  onToggleCompletion: (itemIndex) {
                    setState(() {
                      tasks[taskIndex].items[itemIndex].isCompleted =
                          !tasks[taskIndex].items[itemIndex].isCompleted;
                    });
                  },
                  onToggleExpansion: () {
                    setState(() {
                      tasks[taskIndex].isExpanded =
                          !tasks[taskIndex].isExpanded;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showAddTaskBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text('+ Add Task'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskBottomSheet extends StatefulWidget {
  final Function(List<TaskItem>) onTaskAdded;

  AddTaskBottomSheet({required this.onTaskAdded});

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  List<TextEditingController> controllers = [TextEditingController()];
  List<TaskItem> newTasks = [TaskItem('')];
  DateTime? selectedTime;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 600,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Text(
                  'Add Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final now = DateTime.now();
                          setState(() {
                            selectedTime = DateTime(now.year, now.month,
                                now.day, pickedTime.hour, pickedTime.minute);
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(95, 233, 30, 98),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              selectedTime == null
                                  ? ''
                                  : DateFormat.jm().format(selectedTime!),
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: newTasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter task',
                              ),
                              controller: controllers[index],
                              onChanged: (value) {
                                newTasks[index].text = value;
                              },
                            ),
                            SizedBox(height: 8),
                            if (index == newTasks.length - 1)
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    controllers.add(TextEditingController());
                                    newTasks.add(TaskItem(''));
                                  });
                                },
                                color: Colors.black,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        List<TaskItem> combinedTasks = newTasks
                            .where((task) => task.text.isNotEmpty)
                            .toList();
                        if (combinedTasks.isNotEmpty) {
                          widget.onTaskAdded(combinedTasks);
                        }

                        controllers.clear();
                        newTasks.clear();
                        controllers.add(TextEditingController());
                        newTasks.add(TaskItem(''));
                        selectedTime = null;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TaskListTile extends StatefulWidget {
  final Task task;
  final Function(int) onDelete;
  final Function(int) onToggleCompletion;
  final VoidCallback onToggleExpansion;

  TaskListTile({
    required this.task,
    required this.onDelete,
    required this.onToggleCompletion,
    required this.onToggleExpansion,
  });

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  TextEditingController _newTaskController = TextEditingController();
  DateTime? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.task.time}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(
                _getTaskStatusText(widget.task),
                style: TextStyle(
                  fontSize: 16,
                  color: _getTaskStatusColor(widget.task),
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.task.isExpanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
                onPressed: widget.onToggleExpansion,
              ),
            ],
          ),
          if (widget.task.isExpanded)
            Column(
              children: widget.task.items.asMap().entries.map((entry) {
                int itemIndex = entry.key;
                TaskItem taskItem = entry.value;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: taskItem.isCompleted,
                    onChanged: (bool? value) {
                      widget.onToggleCompletion(itemIndex);
                    },
                    activeColor: Colors.green,
                  ),
                  title: Text(
                    taskItem.text,
                    style: TextStyle(
                      decoration: taskItem.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _showEditBottomSheet(context, itemIndex);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          widget.onDelete(itemIndex);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context, int itemIndex) {
    TaskItem currentTaskItem = widget.task.items[itemIndex];
    _newTaskController.text = currentTaskItem.text;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Task',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _newTaskController,
                      decoration: InputDecoration(labelText: 'New Task Name'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final now = DateTime.now();
                          setState(() {
                            selectedTime = DateTime(now.year, now.month,
                                now.day, pickedTime.hour, pickedTime.minute);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        selectedTime == null
                            ? 'Select Time'
                            : DateFormat.jm().format(selectedTime!),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.task.items[itemIndex] = TaskItem(
                            _newTaskController.text,
                            isCompleted: currentTaskItem.isCompleted,
                            time: selectedTime,
                          );
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                      ),
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  int _countCheckedTasks(Task task) {
    return task.items.where((item) => item.isCompleted).length;
  }

  Color _getTaskStatusColor(Task task) {
    int completedTasks = _countCheckedTasks(task);
    if (completedTasks == 0) {
      return Colors.grey;
    } else if (completedTasks == task.items.length) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }

  String _getTaskStatusText(Task task) {
    int completedTasks = _countCheckedTasks(task);
    int totalTasks = task.items.length;
    if (completedTasks == totalTasks && totalTasks > 0) {
      return 'Completed';
    } else {
      return '$completedTasks/$totalTasks task completed';
    }
  }
}
