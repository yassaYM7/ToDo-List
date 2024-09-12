import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';


class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

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
                  DateFormat.jm().format(DateTime.now()),//DateFormat.jm().format(selectedTime)
                ));
              }
            });
          },
        );
      },
    );
  }

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate, // current selected date
    firstDate: DateTime(2000), // minimum date
    lastDate: DateTime(2101),  // maximum date
  );
  if (picked != null && picked != selectedDate) {
    setState(() {
      selectedDate = picked; // update selectedDate with the new value
      formattedDate = DateFormat('EEE, dd MMMM yyyy').format(selectedDate); // update formattedDate
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
            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.calendar_today, color: Colors.grey),
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
                child: const Text('+ Add Task'),
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

  const AddTaskBottomSheet({super.key, required this.onTaskAdded});

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  List<TextEditingController> controllers = [TextEditingController()];
  List<TaskItem> newTasks = [TaskItem('')];
  DateTime? selectedTime;

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
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
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Time',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              selectedTime == null
                                  ? 'Select Time'
                                  : DateFormat.jm().format(selectedTime!),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter task',
                              ),
                              controller: controllers[index],
                              onChanged: (value) {
                                newTasks[index].text = value;
                              },
                            ),
                            const SizedBox(height: 8),
                            if (index == newTasks.length - 1)
                              IconButton(
                                icon: const Icon(Icons.add),
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
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        List<TaskItem> combinedTasks = newTasks
                            .where((task) => task.text.isNotEmpty)
                            .toList();
                        if (combinedTasks.isNotEmpty) {
                          for (var task in combinedTasks) {
                            task.time = selectedTime;
                          }
                          widget.onTaskAdded(combinedTasks);
                        }

                        for (var controller in controllers) {
                          controller.dispose();
                        }
                        controllers.clear();
                        newTasks.clear();
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Task'),
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

  const TaskListTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleCompletion,
    required this.onToggleExpansion,
  });

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  final TextEditingController _newTaskController = TextEditingController();
  DateTime? selectedTime;

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
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
                  widget.task.time,
                  style: const TextStyle(fontSize: 16),
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
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _showEditBottomSheet(context, itemIndex);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
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
    selectedTime = currentTaskItem.time;

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
              return SizedBox(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Task',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _newTaskController,
                      decoration:
                          const InputDecoration(labelText: 'New Task Name'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              selectedTime ?? DateTime.now()),
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
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                      child: const Text('Confirm'),
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
