import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:to_do_app_with_hive/data/local_storeges.dart';
import 'package:to_do_app_with_hive/main.dart';
import 'package:to_do_app_with_hive/models/task_model.dart';
import 'package:to_do_app_with_hive/widgets/costum_search.dart';
import 'package:to_do_app_with_hive/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();

    _localStorage = localtor<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: (() {
              _showAddTaskBottomSheet(context);
            }),
            child: Text(
              'Bugün Neler Yapacaksın ?',
              style: TextStyle(color: Colors.black),
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(onPressed: () {
              _showSearchPage();


            }, icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _showAddTaskBottomSheet(context);
                },
                icon: Icon(Icons.add)),
          ],
        ),
        body: _allTasks.isNotEmpty
            ? ListView.builder(
                itemCount: _allTasks.length,
                itemBuilder: (context, index) {
                  var _oankiListeEleami = _allTasks[index];
                  return Dismissible(
                      background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 20,
                            ),
                            Text("bu görev silindi")
                          ]),
                      key: Key(_oankiListeEleami.id),
                      onDismissed: ((direction) {
                        _allTasks.removeAt(index);
                        _localStorage.deleteTask(task: _oankiListeEleami);
                        setState(() {});
                      }),
                      child: TaskItem(
                        task: _oankiListeEleami,
                      ));
                },
              )
            : Center(
                child: Text("hadi görev ekle"),
              ));
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    hintText: 'Görev Nedir ?', border: InputBorder.none),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    DatePicker.showTimePicker(
                      context,
                      showSecondsColumn: false,
                      onConfirm: (time) async {
                        var yeniEklenecekGorev =
                            Task.create(name: value, createdAt: time);

                        _allTasks.add(yeniEklenecekGorev);
                        await _localStorage.addTask(task: yeniEklenecekGorev);
                        setState(() {});
                      },
                    );
                  }
                },
              ),
            ),
          );
        }));
  }

  Future<void> _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }
  
  Future<void> _showSearchPage() async {

    await showSearch(context: context, delegate: CustomSearchdelegete(allTasks: _allTasks));

    _getAllTaskFromDb();

  }
}
