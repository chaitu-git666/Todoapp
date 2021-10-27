import 'package:todoapp/models/category.dart';
import 'package:todoapp/repositories/repository.dart';

class CategoryService {
  Repository _repository;
  CategoryService() {
    _repository = Repository();
  }
//create data
  saveCategory(Category category) async {
    return await _repository.insertData('categories', category.categoryMap());
  }

  //read data from table
  readCategories() async {
    return await _repository.readData('categories');
  }

  //read category by id
  readCategoriesById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

//update data from table
  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.categoryMap());
  }

//delete  data from table
  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories', categoryId);
  }
}
