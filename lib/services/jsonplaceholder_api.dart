import 'dart:convert';

import 'package:debt_tracker/models/todo.dart';
import 'package:http/http.dart' as http;

Map<String, String> headers = {
  'Content-type': 'application/json; charset=UTF-8',
};

Future<http.Response> fetchTodoList() async {
  final response = await http.get('http://jsonplaceholder.typicode.com/todos');
  return response;
}

Future<http.Response> updateTodoItem(Todo item) async {
  String itemId = item.id.toString();
  final response = await http.put(
      'http://jsonplaceholder.typicode.com/todos/$itemId',
      body: json.encode(item.toJson()));
  return response;
}
