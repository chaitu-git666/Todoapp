import 'package:flutter/material.dart';
import 'package:todoapp/Screens/todo_screen.dart';
import 'package:todoapp/helpers/drawer_navigation.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;

  List<Todo> _todoList = <Todo>[];
  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = <Todo>[];

    var todos = await _todoService.readTodo();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        title: const Text(
          'TodoApp',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_todoList[index].title ?? 'No title'),
                    ],
                  ),
                  subtitle:
                      Text(_todoList[index].description ?? 'No description'),
                  trailing: Text(_todoList[index].todoDate ?? 'No date'),
                ),
              ),
            );
          }),
      drawer: const DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const TodoScreen()),
        ),
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
