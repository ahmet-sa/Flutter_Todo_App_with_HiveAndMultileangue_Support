import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_hive/main.dart';
import 'package:to_do_app_with_hive/models/task_model.dart';

import '../data/local_storeges.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage=localtor<LocalStorage>();
    _taskNameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskNameController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (yenideger){
                  if(yenideger.length>3){
                      widget.task.name=yenideger;
                      _localStorage.updateTask(task: widget.task);

                  }
                 

                }
              ),


           trailing:Text(DateFormat("hh:mm a").format(widget.task.createdAt),style:const TextStyle(fontSize: 12,color: Colors.grey) ,),
      ),
    );
  }
}
