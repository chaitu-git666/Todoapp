import 'package:flutter/material.dart';
import 'package:todoapp/Screens/categories_screen.dart';
import 'package:todoapp/Screens/home_screen.dart';
import 'package:todoapp/Screens/todos_by_category.dart';
import 'package:todoapp/services/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  final List<Widget> _categoryList = <Widget>[];
  final CategoryService _categoryService = CategoryService();
  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TodosByCategory(
                        category: category['name'],
                      ))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.thestatesman.com/wp-content/uploads/2019/10/dhoni-no-7.jpg'),
              ),
              accountName: Text('Chaitanya'),
              accountEmail: Text('chaituc446@gmail.com'),
              decoration: BoxDecoration(color: Colors.deepOrange),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text(
                'Categories',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CategoriesScreen())),
            ),
            const Divider(),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}
