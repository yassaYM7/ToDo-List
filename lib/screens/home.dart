import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(229, 255, 255, 255),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 20),
                        child: const Text(
                          'My To-Do Tasks',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                          onEditItem: _editToDoItem,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(252, 245, 245, 240),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: ' Add New Task',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      final updatedToDo = todo.copyWith(isDone: !todo.isDone);
      final index = todosList.indexWhere((item) => item.id == todo.id);
      if (index != -1) {
        todosList[index] = updatedToDo;
        _foundToDo = todosList
            .where((item) => item.todoText!
                .toLowerCase()
                .contains(_todoController.text.toLowerCase()))
            .toList();
      }
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _foundToDo = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(_todoController.text.toLowerCase()))
          .toList();
    });
  }

  void _editToDoItem(ToDo todo) async {
    TextEditingController editController =
        TextEditingController(text: todo.todoText);
    DateTime? selectedDate = todo.time;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit ToDo Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editController,
                decoration: const InputDecoration(labelText: 'Edit ToDo'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          selectedDate ?? DateTime.now()),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        selectedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text(
                  selectedDate != null
                      ? DateFormat.yMMMd().format(selectedDate!) +
                          ' at ' +
                          DateFormat.jm().format(selectedDate!)
                      : 'Select Date & Time',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todo.todoText = editController.text;
                  todo.time = selectedDate;
                  _foundToDo = todosList
                      .where((item) => item.todoText!
                          .toLowerCase()
                          .contains(_todoController.text.toLowerCase()))
                      .toList();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addToDoItem(String toDo) async {
    if (toDo.isEmpty) {
      return;
    }

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((pickedDate) async {
      if (pickedDate != null) {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          return DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      }
      return null;
    });

    if (selectedDate != null) {
      setState(() {
        todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo,
          time: selectedDate,
        ));
        _foundToDo = todosList
            .where((item) => item.todoText!
                .toLowerCase()
                .contains(_todoController.text.toLowerCase()))
            .toList();
      });
      _todoController.clear();
    }
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(224, 255, 253, 253),
      elevation: 2,
      title: const Text('To_Do List',
          style: TextStyle(color: Color.fromARGB(255, 14, 14, 14))),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.orange),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.orange),
          onPressed: () {
            _clearCompletedTasks();
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          labelText: 'Search',
          labelStyle: const TextStyle(color: Colors.black),
          fillColor: Colors.black.withOpacity(0.1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  void _clearCompletedTasks() {
    setState(() {
      todosList.removeWhere((todo) => todo.isDone);
      _foundToDo = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(_todoController.text.toLowerCase()))
          .toList();
    });
  }
}
