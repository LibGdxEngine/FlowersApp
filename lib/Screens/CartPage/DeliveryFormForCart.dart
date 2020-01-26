import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/Models/Order.dart';
import 'package:untitled6/Screens/CartPage/FinishOrderPage.dart';

class DeliveryFormForCart extends StatefulWidget {
  static final id = "DeliveryFormForCart";
  @override
  _DeliveryFormForCartState createState() => _DeliveryFormForCartState();
}

double _width, _height;

class _DeliveryFormForCartState extends State<DeliveryFormForCart> {
  String _location;
  String _phone;
  String _notes;
  String _name;
  List<String> ordersItemsIDs;
  bool isLoading = false;

  Future<bool> getCartDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    List<String> cartList = (prefs.getStringList('cart') ?? temp);
    ordersItemsIDs = cartList;
  }

  void _createNewOrder() {
    setState(() {
      isLoading = true;
    });
    final CollectionReference ordersCollection =
        Firestore.instance.collection('Orders');
    ordersCollection.add(Order(
      name: _name,
      id: Random.secure().nextInt(3 ^ 32).toString(),
      location: _location,
      notes: _notes,
      reference: null,
      phone: _phone,
      ordersItemsIDs: ordersItemsIDs,
    ).toMap());
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCartDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    // Build a Form widget using the _formKey created above.
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'اكمل بيانات الطلب',
                style: TextStyle(fontSize: 25),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Add TextFormFields and RaisedButton here.
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 50, right: 50, bottom: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          hintText: 'الاسم',
                        ),
                        onChanged: (value) {
                          _name = value;
                        },
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 50, right: 50, bottom: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          hintText: 'العنوان',
                        ),
                        onChanged: (value) {
                          _location = value;
                        },
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 50, right: 50, bottom: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          hintText: 'رقم الهاتف',
                        ),
                        onChanged: (value) {
                          _phone = value;
                        },
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذه الحقل مطلوب';
                          }
                          return null;
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 50, right: 50, bottom: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          hintText: 'ملاحظات',
                        ),
                        onChanged: (value) {
                          _notes = value;
                        },
                      ),
                    ),
                    RaisedButton(
                      color: Colors.purple,
                      //disale this button while uploading
                      onPressed: !isLoading
                          ? () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState.validate() &&
                                  _name != null &&
                                  _location != null &&
                                  _phone != null) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                _createNewOrder();
                                Future.delayed(Duration(milliseconds: 2000));
                                Navigator.pushNamed(context, FinishOrder.id);
                              }
                            }
                          : null,
                      child: !isLoading
                          ? Text(
                              'اطلب الان',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )
                          : CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
