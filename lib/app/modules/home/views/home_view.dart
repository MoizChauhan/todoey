import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:todoey/app/Widgets/custom_button.dart';
import 'package:todoey/app/Widgets/delete_dialog.dart';
import 'package:todoey/app/data/task_model.dart';
import 'package:todoey/utils/generate_id.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.taskController.text = "";
          Get.bottomSheet(addDailog(context));
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.list,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Todoey',
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Obx(() => Text(
                        '${controller.taskLength} Tasks',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )),
                    child: StreamBuilder<List<TaskModel>>(
                        stream: controller.tasks,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          if (snapshot.data!.length == 0) return Center(child: Text("No Data available"));
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    // controller.taskLength.value = snapshot.data!.length;
                                    TaskModel task = snapshot.data![index];
                                    return InkWell(
                                      onLongPress: () {
                                        deleteDialog(
                                            entity: "Are you sure you want to delete this task?",
                                            function: () {
                                              Get.back();
                                              controller.delete(task.id);
                                            });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              task.task,
                                              style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.normal,
                                                decoration: task.isSelected ? TextDecoration.lineThrough : TextDecoration.none,
                                              ),
                                            ),
                                            // value: index % 2 == 0 ? false : true,
                                            Padding(
                                              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: task.isSelected ? Colors.black : Colors.black,
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(5),
                                                    )),
                                                width: 20,
                                                height: 20,
                                                child: Theme(
                                                  data: ThemeData(
                                                    unselectedWidgetColor: Colors.transparent,
                                                  ),
                                                  child: Checkbox(
                                                    activeColor: Colors.black,
                                                    checkColor: Colors.white,
                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    visualDensity: VisualDensity.standard,
                                                    value: task.isSelected,
                                                    tristate: false,
                                                    onChanged: (bool? isChecked) {
                                                      task.isSelected = !task.isSelected;
                                                      controller.updateTask(task);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 100,
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addDailog(context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            'Add Task',
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller.taskController,
            autofocus: true,
            onSubmitted: (text) {
              addFunction(context);
            },
          ),
          SizedBox(height: 20),
          CustomButton("Add", 0, 0, () {
            addFunction(context);
          }),
        ],
      ),
    );
  }

  addFunction(context) {
    if (controller.taskController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Task Cannot be empty"),
        backgroundColor: Colors.red,
      ));
    } else {
      TaskModel task = TaskModel(id: getRandomString(10), task: controller.taskController.text, isSelected: false);
      controller.addTask(task);
      Get.back();
    }
  }
}
