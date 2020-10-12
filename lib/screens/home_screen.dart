import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:debt_tracker/models/todo.dart';
import 'package:debt_tracker/services/jsonplaceholder_api.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    _fetchTodoList();
    super.initState();
  }

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
              title: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final response =
                              await deleteTodoItem(todos[index].id);
                          if (response.statusCode == 200) {
                            setState(() {
                              todos.remove(todos[index]);
                            });
                          }
                        }),
                    Expanded(
                      child: AutoSizeText(
                        todos[index].title,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ),
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
          final modalResponse = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return _dialog();
              });
          if (modalResponse == null || modalResponse == '') {
            return;
          }
          final response = await saveTodoItem(modalResponse.toString());
          if (response.statusCode == 201) {
            final parsedJson = json.decode(response.body);
            Todo _todoId = Todo.fromJson(parsedJson);
            todos.add(_todoId.copyWith(
                userId: 1, title: modalResponse, completed: false));
            setState(() {});
          }
        },
        tooltip: 'Add To Do',
        child: Icon(Icons.add),
      ),
    );
  }

  _fetchTodoList() async {
    final response = await fetchTodoList();
    print('test');
    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      todos = Todo.fromJsonToList(parsedJson);
      setState(() {});
    }
  }

  Widget _dialog() {
    TextEditingController _text = TextEditingController(text: '');
    return SimpleDialog(
      title: const Text('Add new item'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
          child: TextFormField(
            controller: _text,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
        Row(
          children: [
            Spacer(),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(_text.text);
              },
              child: Text('Save'),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'))
          ],
        )
      ],
    );
  }
}
