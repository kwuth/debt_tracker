import 'package:flutter/foundation.dart';

class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Todo(
      {@required this.userId,
      @required this.id,
      @required this.title,
      @required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed']);

  Todo copyWith({int userId, int id, String title, bool completed}) => Todo(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed);

  static List<Todo> fromJsonToList(List<dynamic> parsedJson) {
    if (parsedJson == null || parsedJson.length == 0) return [];
    List<Todo> values = List();
    for (var i = 0; i < parsedJson.length; i++) {
      values.add(Todo.fromJson(parsedJson[i]));
    }
    return values;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['completed'] = this.completed;
    return data;
  }
}
