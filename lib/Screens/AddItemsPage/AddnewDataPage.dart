import 'package:flutter/material.dart';
import 'package:untitled6/Screens/AddItemsPage/CategoryForm.dart';
import 'package:untitled6/Screens/AddItemsPage/ItemForm.dart';

class AddNewCtegoryPage extends StatefulWidget {
  static final id = "AddNewCtegoryPage";
  @override
  _AddNewCtegoryPageState createState() => _AddNewCtegoryPageState();
}

class _AddNewCtegoryPageState extends State<AddNewCtegoryPage> {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    String function = args['function'];
    Widget widget;
    switch (function) {
      case 'addnewitem':
        String _category = args['category'];
        widget = AddNewItemForm(category: _category);
        break;
      case 'addnewcategory':
        widget = AddCategoryForm();
        break;
    }
    return MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );
  }
}
