import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;
  const TodosByCategory({Key key, this.category}) : super(key: key);

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  final List<Todo> _todosList = <Todo>[];
  final TodoService _todoService = TodoService();
  @override
  initState() {
    super.initState();
    getTodosByCategory();
  }

  getTodosByCategory() async {
    // ignore: unnecessary_this
    var todos = await _todoService.readTodosByCategory(this.widget.category);
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];

        _todosList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        // ignore: unnecessary_this
        title: Text(this.widget.category),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _todosList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        elevation: 8,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_todosList[index].title),
                            ],
                          ),
                          subtitle: Text(_todosList[index].description),
                          trailing: Text(_todosList[index].todoDate),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
