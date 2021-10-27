// ignore_for_file: avoid_print, deprecated_member_use, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:todoapp/Screens/home_screen.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _categoryNamecontroller = TextEditingController();
  final _categoryDescriptionController = TextEditingController();

  final _category = Category();
  final _categoryService = CategoryService();
  List<Category> _categoryList = <Category>[];
  var category;

  final _editNamecontroller = TextEditingController();
  final _editDescriptionController = TextEditingController();
  void clearTextInput() {
    _categoryNamecontroller.clear();
    _categoryDescriptionController.clear();
  }

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.descrption = category['descrption'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoriesById(categoryId);
    setState(() {
      _editNamecontroller.text = category[0]['name'] ?? 'no name';
      _editDescriptionController.text =
          category[0]['description'] ?? 'no description';
    });
    _editFormDailog(context);
  }

  _showFormDailog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.green, primary: Colors.white),
                onPressed: () async {
                  _category.name = _categoryNamecontroller.text;
                  _category.descrption = _categoryDescriptionController.text;
                  var result = await _categoryService.saveCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    clearTextInput();
                    getAllCategories();
                  }
                },
                child: const Text('save'),
              )
            ],
            title: const Text('Categories Form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _categoryNamecontroller,
                    decoration: const InputDecoration(
                      hintText: 'write a category',
                      labelText: 'Category',
                    ),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: const InputDecoration(
                      hintText: 'write a description',
                      labelText: 'Description',
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _editFormDailog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.green, primary: Colors.white),
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editNamecontroller.text;
                  _category.descrption = _editDescriptionController.text;

                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(const Text('Updated'));
                  }
                },
                child: const Text('update'),
              )
            ],
            title: const Text('Edit Categories Form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editNamecontroller,
                    decoration: const InputDecoration(
                      hintText: 'write a category',
                      labelText: 'Category',
                    ),
                  ),
                  TextField(
                    controller: _editDescriptionController,
                    decoration: const InputDecoration(
                      hintText: 'write a description',
                      labelText: 'Description',
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDailog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.green),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red, primary: Colors.white),
                onPressed: () async {
                  var result =
                      await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(const Text('Deleted'));
                  }
                },
                child: const Text('Delete'),
              )
            ],
            title: const Text('Are you sure you want to delete this?'),
          );
        });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen())),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
        ),
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      _editCategory(context, _categoryList[index].id);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_categoryList[index].name),
                      IconButton(
                        onPressed: () {
                          _deleteFormDailog(context, _categoryList[index].id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
        onPressed: () {
          _showFormDailog(context);
        },
      ),
    );
  }
}
