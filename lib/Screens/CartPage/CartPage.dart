import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/Screens/CartPage/DeliveryFormForCart.dart';
import 'package:untitled6/Screens/FullScreenImageViewPage/FullScreenPage.dart';

import '../../Models/Item.dart';

class CartPage extends StatefulWidget {
  static final id = 'CartPage';
  @override
  _CartPageState createState() => _CartPageState();
}

double _width, _height;
List<String> cartListItems = [];
//pointer to delete from cart funtion
Function delete;

class _CartPageState extends State<CartPage> {
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

    Future<void> deleteThisItemFromCart(BuildContext context, String id) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> temp = [];
      List<String> cartList = (prefs.getStringList('cart') ?? temp);
      if (cartList.contains(id)) {
        cartList.remove(id);
        setState(() {
          cartListItems = cartList;
        });
        await prefs.setStringList('cart', cartList);
      } else {
        print('This item doesn\'t exists');
      }
    }

    /* * * */
    delete = deleteThisItemFromCart;
    /* * * */
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('سلة المشتريات'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, DeliveryFormForCart.id);
            },
            child: Icon(
              Icons.shop,
              color: Colors.white,
            ),
          ),
        ),
        body: cartCurrentItems > 0
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Text(
                        'اطلب الان لخدمة التوصيل',
                        style: TextStyle(
                            fontSize: 35,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: _width,
                        height: _height - 200,
                        child: _buildBody(context),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.remove_shopping_cart,
                      color: Colors.red,
                      size: 100,
                    ),
                    Text('سلة المشتريات فارغة'),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCartDataFromSharedPreferences();
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('items').snapshots(),
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
  final item = Item.fromSnapshot(data);

  return cartListItems.contains(item.id)
      ? Padding(
          key: ValueKey(item.title),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purpleAccent),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: MyItem(context, item),
          ),
        )
      : Container();
}

void goToFullScreebPage(BuildContext context, String image, String title) {
  Navigator.pushNamed(
    context,
    FullScreen.id,
    arguments: {"image": image, 'title': title},
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
                  delete(context, item.id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ازالة من السلة',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.remove,
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
                      'مشاركة الصورة',
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

Future<bool> getCartDataFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> temp = [];
  List<String> cartList = (prefs.getStringList('cart') ?? temp);
  cartListItems = cartList;
}
