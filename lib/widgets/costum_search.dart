import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_app_with_hive/data/local_storeges.dart';
import 'package:to_do_app_with_hive/widgets/task_list_item.dart';

import '../main.dart';
import '../models/task_model.dart';

class CustomSearchdelegete extends SearchDelegate {
late final List< Task> allTasks;
  CustomSearchdelegete({required this.allTasks});



 @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.red,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {{

  var filteredlist = allTasks.where((gorev) => gorev.name.toLowerCase().contains(query.toLowerCase())).toList();
  return  filteredlist.length>0 ?       ListView.builder(
                itemCount: filteredlist.length,
                itemBuilder: (context, index) {
                  var _oankiListeEleami = filteredlist[index];
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
                      onDismissed: ((direction) async {
                        filteredlist.removeAt(index);
                        await localtor <LocalStorage>().deleteTask(task:_oankiListeEleami);
                        
                      }),
                      child: TaskItem(
                        task: _oankiListeEleami,
                      ));
                },
              ):Center(child: Text("aranan bulunamdamı"),);
  


  };
    



  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
