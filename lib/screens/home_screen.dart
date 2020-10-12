import 'dart:convert';

import 'package:debt_tracker/models/todo.dart';
import 'package:debt_tracker/services/jsonplaceholder_api.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, index) {
            return SwitchListTile(
              value: todos[index].completed,
              title: Text(todos[index].title),
              onChanged: (value) async {
                Todo updatedItem = todos[index].copyWith(completed: value);

                final response = await updateTodoItem(updatedItem);
                if (response.statusCode == 200) {
                  setState(() {
                    todos[index] = updatedItem;
                  });
                }
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final response = await fetchTodoList();
          print('test');
          if (response.statusCode == 200) {
            final parsedJson = json.decode(response.body);
            todos = Todo.fromJsonToList(parsedJson);
            setState(() {});
          }
        },
        tooltip: 'Add To Do',
        child: Icon(Icons.add),
      ),
    );
  }
}
