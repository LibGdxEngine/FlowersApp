import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/Models/Item.dart';
import 'package:untitled6/Screens/AddItemsPage/AddnewDataPage.dart';
import 'package:untitled6/Screens/CartPage/CartPage.dart';
import 'package:untitled6/Screens/FullScreenImageViewPage/FullScreenPage.dart';

class ItemsPage extends StatefulWidget {
  static final id = "ItemsPage";
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

double _width, _height;
Item _itemToDelete;

class _ItemsPageState extends State<ItemsPage> {
  int cartCurrentItems = 0;

  Future<bool> getCartItemsLength() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    List<String> cartList = (prefs.getStringList('cart') ?? temp);
    setState(() {
      cartCurrentItems = cartList.length;
    });
  }

  void _goToCartPage(BuildContext context) {
    Navigator.pushNamed(context, CartPage.id);
  }

  @override
  Widget build(BuildContext context) {
    getCartItemsLength();
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    String _category = args['category'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_category),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            goToNewItemAddingPage(context, _category);
          },
          tooltip: 'اضافة عنصر',
          child: Icon(Icons.add),
        ),
        body: Container(
          child: Center(
            child: _buildBody(context, _category),
          ),
        ),
      ),
    );
  }
}

Widget _buildBody(BuildContext context, String category) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('items')
        .where('category', isEqualTo: category)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();

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
  final item = Item.fromSnapshot(data);
  return Padding(
    key: ValueKey(item.title),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: MyItem(context, item),
    ),
  );
}

Widget MyItem(BuildContext context, Item item) {
  return Container(
    child: Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            goToFullScreebPage(context, item.image, item.title);
          },
          onLongPress: () {
            _showAlert(context, "هل انت متأكد انك تريد حذف هذه الصورة ؟");
            _itemToDelete = item;
          },
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
            ),
            child: Center(
              child: Stack(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    height: _height / 5,
                    width: _width,
                    placeholder: 'images/white.jpeg',
                    image: item.image,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: _height / 7.9,
                    left: 20,
                    right: 20,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: _width / 2 - 20,
              height: 50,
              child: RaisedButton(
                color: Colors.purple,
                onPressed: () {
                  addThisItemToCart(context, item.id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'اضافة الى السلة',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.add_shopping_cart,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              color: Colors.red,
            ),
            Container(
              width: _width / 2 - 20,
              height: 50,
              child: RaisedButton(
                color: Colors.purple,
                onPressed: () {
                  _shareImage(item.image, item.title);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'مشاركة',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void _shareImage(String image, String title) {
  Share.share(image, subject: title);
}

Future<void> addThisItemToCart(BuildContext context, String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> temp = [];
  printCartData();
  List<String> cartList = (prefs.getStringList('cart') ?? temp);
  if (!cartList.contains(id)) {
    cartList.add(id);
    await prefs.setStringList('cart', cartList);
    _showSuccessfullyAdded(context, 'تمت الاضافة الى سلتك ...شكرا لك');
  } else {
    print('This item already exists');
    showAlreadyExistInCartMessage(context, 'هذا العنصر موجود بالفعل في سلتك !');
  }
}

void _showSuccessfullyAdded(BuildContext context, String successMessage) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
}

void showAlreadyExistInCartMessage(BuildContext context, String value) {
  _showAlreadyExistDialog(context, value);
}

void printCartData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cartList = prefs.getStringList('cart');
  print('cart data is ${cartList.toString()}');
}

void goToNewItemAddingPage(BuildContext context, String category) {
  Navigator.pushNamed(context, AddNewCtegoryPage.id,
      arguments: {'function': 'addnewitem', 'category': category});
}

void goToFullScreebPage(BuildContext context, String image, String title) {
  Navigator.pushNamed(
    context,
    FullScreen.id,
    arguments: {"image": image, 'title': title},
  );
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

void _showAlreadyExistDialog(BuildContext context, String value) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text('لا تضغط كثيرا'),
            content: new Text(
              value,
              style: new TextStyle(fontSize: 25.0),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('حسنا')),
            ],
          ));
}

void _dialogueResult(MyDialogueAction value, BuildContext context) {
  if (value == MyDialogueAction.yes) {
    _itemToDelete.reference.delete();
    Navigator.pop(context);
  } else {
    Navigator.pop(context);
  }
}

enum MyDialogueAction { yes, no, maybe }
