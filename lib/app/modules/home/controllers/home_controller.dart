import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todoey/app/data/task_model.dart';
import 'package:todoey/service/db_service.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  TextEditingController taskController = TextEditingController();
  List<TaskModel> taskList = List<TaskModel>.empty(growable: true);
  final _taskController = StreamController<List<TaskModel>>.broadcast();
  get tasks => _taskController.stream;
  var taskLength = 0.obs;
  @override
  void onClose() {
    _taskController.close();
    super.onClose();
  }

  getAllTask() async {
    print("Get Task");
    _taskController.sink.add(await DBProvider.db.getAllTasks());
    getCount();
  }

  getCount() async {
    taskLength.value = await DBProvider.db.getAllTaskLength();
    print("Tasks" + taskLength.value.toString());
  }

  @override
  void onInit() {
    super.onInit();
    getAllTask();
  }

  updateTask(TaskModel client) {
    DBProvider.db.updateTaskStatus(client);
    getAllTask();
  }

  delete(String id) {
    DBProvider.db.deleteTask(id);
    getAllTask();
  }

  addTask(TaskModel task) {
    DBProvider.db.newTask(task);
    getAllTask();
  }
}
