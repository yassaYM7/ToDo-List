import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../bottom_sheets/task_bottom_sheet.dart';
import '../controllers/task_controller.dart';
import '../widgets/expansion_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          backgroundColor: const Color(0xfffefefe),
          appBar: AppBar(
            backgroundColor: const Color(0xfffefefe),
            toolbarHeight: 100,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    color: Color(0xff141414),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, 
                          width: 2.0, 
                        ),
                        borderRadius: BorderRadius.circular(20), 
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 2), 
                      child: Row(
                        children: [
                          Text(
                            DateFormat('EEE, dd MMMM yyyy').format(selectedDate),
                            style: const TextStyle(
                              color: Color(0xff888888),
                              fontSize: 18, 
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                              size: 18, 
                            ),
                            onPressed: _selectDate,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: ListView.builder(
            itemCount: TaskController.panels.length,
            itemBuilder: (context, index) {
              final panel = TaskController.panels[index];
              return ExpansionPanelItem(
                panel: panel,
                onDeleteTask: (task) {
                  setState(() {
                    TaskController.deleteTask(panel, task);
                    if (panel.items.isEmpty) {
                      TaskController.deletePanel(panel);
                    }
                  });
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 350,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                side: const BorderSide(
                  width: 2,
                  style: BorderStyle.solid,
                ),
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  context: context,
                  builder: (context) {
                    return TaskBottomSheet(
                      onAdd: (panel) {
                        setState(() {
                          TaskController.addPanel(panel);
                        });
                      },
                    );
                  },
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 26,
                    color: Colors.white,
                  ),
                  Text(
                    " Add Task",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
