import 'package:flutter/material.dart';
import 'package:get/get.dart';

deleteDialog({entity, function}) {
  Get.dialog(
    AlertDialog(
      title: Text('${entity.toString()}'),
      //content: Text("This should not be closed automatically"),
      actions: <Widget>[
        TextButton(
          child: Text("Yes"),
          onPressed: function,
        ),
        TextButton(
          child: Text("No"),
          onPressed: () {
            Get.back(result: false);
          },
        )
      ],
    ),
    barrierDismissible: false,
  );
}
