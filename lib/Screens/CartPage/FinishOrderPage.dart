import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/Screens/HomePage/Home.dart';

class FinishOrder extends StatefulWidget {
  static final id = "FinishOrder";
  @override
  _FinishOrderState createState() => _FinishOrderState();
}

class _FinishOrderState extends State<FinishOrder> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.purple,
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 75,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('لقد تم ارسال طلبك ... سيتم التواصل معك قريبا'),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    deleteCartDataFromSharedPreferences();
                    Navigator.pushNamed(context, MyHomePage.id);
                  },
                  color: Colors.purple,
                  child: Text(
                    'حسنا',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> deleteCartDataFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> temp = [];
  List<String> cartList = (prefs.getStringList('cart') ?? temp);
  await prefs.setStringList('cart', []);
}
