// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _todoTitleController = TextEditingController();

  final _todoDescriptionController = TextEditingController();

  final _todoDateController = TextEditingController();

  var _selectedValue;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  final _categories = <DropdownMenuItem>[];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat.yMMMd().format(_pickedDate);
      });
    }
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    // ignore: deprecated_member_use
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoTitleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Write Todo Title',
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Write Todo Description',
              ),
            ),
            TextField(
              controller: _todoDateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'pick a Date',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectedTodoDate(context);
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButton(
              items: _categories,
              value: _selectedValue,
              hint: const Text('Category'),
              onChanged: (value) => {
                setState(() {
                  _selectedValue = value;
                }),
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var todoObject = Todo();

                todoObject.title = _todoTitleController.text;
                todoObject.description = _todoDescriptionController.text;
                todoObject.isFinished = 0;
                todoObject.todoDate = _todoDateController.text;
                todoObject.category = _selectedValue.toString();

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                if (result > 0) {
                  _showSuccessSnackBar(const Text('Saved'));
                  Navigator.pop(context);
                }
                // ignore: avoid_print
                print(result);
              },
              child: const Text('save'),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
