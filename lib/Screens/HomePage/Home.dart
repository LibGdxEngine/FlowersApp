import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/Screens/AddItemsPage/AddnewDataPage.dart';
import 'package:untitled6/Screens/CartPage/CartPage.dart';
import 'package:untitled6/Screens/ItemsPage/ItemsPage.dart';

import '../../Models/Record.dart';

/***
 *
 * Page to show main Records ( Categories )
 *
 ***/
class MyHomePage extends StatefulWidget {
  static final id = "MyHomePage";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

double _width;
double _height;
Record _reordToDelete;

enum MyDialogueAction { yes, no, maybe }

class _MyHomePageState extends State<MyHomePage> {
  int cartCurrentItems = 0;

  Future<bool> getCartItemsLength() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    List<String> cartList = (prefs.getStringList('cart') ?? temp);
    setState(() {
      cartCurrentItems = cartList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    getCartItemsLength();
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Flowers App"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 18),
            child: GestureDetector(
              onTap: () {
                _goToCartPage(context);
              },
              child: Container(
                width: 35,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      size: 20,
                      color: Colors.white,
                    ),
                    cartCurrentItems > 0
                        ? Positioned(
                            top: 14,
                            left: 15,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.red,
                              child: Text(
                                cartCurrentItems.toString(),
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: _width,
        height: _height,
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.1,
              child: Container(
                width: _width,
                height: _height,
                child: Image.asset(
                  'images/background.jpeg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            _buildBody(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: goToAddPage,
        tooltip: 'اضافة تصنيف',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void goToAddPage() {
    Navigator.pushNamed(context, AddNewCtegoryPage.id,
        arguments: {'function': 'addnewcategory'});
  }
}

void _goToCartPage(BuildContext context) {
  Navigator.pushNamed(context, CartPage.id);
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('categories').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  return Padding(
    key: ValueKey(record.title),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: MyItem(context, record),
    ),
  );
}

Widget MyItem(BuildContext context, Record record) {
  return GestureDetector(
    onTap: () {
      record.reference.updateData({'votes': FieldValue.increment(1)});
      Navigator.pushNamed(context, ItemsPage.id,
          arguments: {'category': record.title});
    },
    onLongPress: () {
      _showAlert(context, 'هل تريد حقا مسح هذا التصنيف ؟');
      _reordToDelete = record;
    },
    child: Container(
      width: _width,
      height: _height / 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(record.image),
            radius: _height / 16,
            backgroundColor: Colors.pink.withAlpha(2),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 25),
            child: Container(
              width: _width * 0.50,
              height: _height / 7,
              alignment: Alignment.center,
              child: Text(
                record.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black87,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

///هخهخهخخههخهخخهخه
void _dialogueResult(MyDialogueAction value, BuildContext context) {
  if (value == MyDialogueAction.yes) {
    Navigator.pop(context);
    _showAlert2(context, 'هل انت متأكد انك متأكد ؟');
  } else {
    Navigator.pop(context);
  }
}

void _dialogueResult2(MyDialogueAction value, BuildContext context) {
  if (value == MyDialogueAction.yes) {
    Navigator.pop(context);
    _showAlert3(context, 'احلف بالله انك متأكد !');
  } else {
    Navigator.pop(context);
  }
}

void _dialogueResult3(MyDialogueAction value, BuildContext context) {
  if (value == MyDialogueAction.yes) {
    Navigator.pop(context);
    _reordToDelete.reference.delete();
  } else {
    Navigator.pop(context);
  }
}

void _showAlert(BuildContext context, String value) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text('تحذير !'),
            content: new Text(
              value,
              style: new TextStyle(fontSize: 25.0),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    _dialogueResult(MyDialogueAction.yes, context);
                  },
                  child: new Text('نعم')),
              new FlatButton(
                  onPressed: () {
                    _dialogueResult(MyDialogueAction.no, context);
                  },
                  child: new Text('لا')),
            ],
          ));
}

void _showAlert2(BuildContext context, String value) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text('تحذير !'),
            content: new Text(
              value,
              style: new TextStyle(fontSize: 25.0),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    _dialogueResult2(MyDialogueAction.yes, context);
                  },
                  child: new Text('نعم متأكد ')),
              new FlatButton(
                  onPressed: () {
                    _dialogueResult2(MyDialogueAction.no, context);
                  },
                  child: new Text('تراجع')),
            ],
          ));
}

void _showAlert3(BuildContext context, String value) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text('تحذير !'),
            content: new Text(
              value,
              style: new TextStyle(fontSize: 25.0),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    _dialogueResult3(MyDialogueAction.yes, context);
                  },
                  child: new Text('والله متأكد')),
              new FlatButton(
                  onPressed: () {
                    _dialogueResult3(MyDialogueAction.no, context);
                  },
                  child: new Text('خلاص مش لازم')),
            ],
          ));
}
