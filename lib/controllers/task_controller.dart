import '../models/panel_model.dart';

class TaskController {
  static List<PanelModel> panels = [];

  static void addPanel(PanelModel panel) {
    panels.add(panel);
  }

  static void deletePanel(PanelModel panel) {
    panels.remove(panel);
  }

  static void editTask(TaskItem task, String newDescription) {
    task.description = newDescription;
  }

  static void deleteTask(PanelModel panel, TaskItem task) {
    panel.items.remove(task);
  }
}
