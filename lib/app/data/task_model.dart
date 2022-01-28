import 'dart:convert';

TaskModel clientFromJson(String str) {
  final jsonData = json.decode(str);
  return TaskModel.fromMap(jsonData);
}

String clientToJson(TaskModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class TaskModel {
  String id;
  String task;
  bool isSelected;

  TaskModel({
    required this.id,
    required this.task,
    required this.isSelected,
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => new TaskModel(
        id: json["id"],
        task: json["task"],
        isSelected: json["isSelected"] == 1,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "task": task,
        "isSelected": isSelected,
      };
}
