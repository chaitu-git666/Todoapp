import 'package:todoapp/models/todo.dart';
import 'package:todoapp/repositories/repository.dart';

class TodoService {
  Repository _repository;
  TodoService() {
    _repository = Repository();
  }
//create data
  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  //read data
  readTodo() async {
    return await _repository.readData('todos');
  }

  //read todos by category
  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
  }
}
