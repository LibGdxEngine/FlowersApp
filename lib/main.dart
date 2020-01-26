import 'package:flutter/material.dart';
import 'package:untitled6/Screens/AddItemsPage/AddnewDataPage.dart';
import 'package:untitled6/Screens/CartPage/CartPage.dart';
import 'package:untitled6/Screens/CartPage/DeliveryFormForCart.dart';
import 'package:untitled6/Screens/CartPage/FinishOrderPage.dart';
import 'package:untitled6/Screens/FullScreenImageViewPage/FullScreenPage.dart';
import 'package:untitled6/Screens/ItemsPage/ItemsPage.dart';

import 'Screens/HomePage/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        AddNewCtegoryPage.id: (context) => AddNewCtegoryPage(),
        ItemsPage.id: (context) => ItemsPage(),
        FullScreen.id: (context) => FullScreen(),
        CartPage.id: (context) => CartPage(),
        DeliveryFormForCart.id: (context) => DeliveryFormForCart(),
        FinishOrder.id: (context) => FinishOrder(),
      },
      initialRoute: MyHomePage.id,
    );
  }
}
