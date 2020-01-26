import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled6/Models/Record.dart';

// Define a custom Form widget.
class AddCategoryForm extends StatefulWidget {
  @override
  AddCategoryFormState createState() {
    return AddCategoryFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
double _width, _height;

class AddCategoryFormState extends State<AddCategoryForm> {
  File _image;
  String _imageUrl;
  String _title;
  bool _uploading = false;

  Future _getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = image;
    });
  }

  Future<void> _addNewListItem() async {
    final StorageReference storageReference = FirebaseStorage()
        .ref()
        .child(Random.secure().nextInt(2 ^ 32).toString());

    final StorageUploadTask uploadTask = storageReference.putFile(_image);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      if (event.type.toString() == "StorageTaskEventType.progress") {
        setState(() {
          _uploading = true;
        });
      }

      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.
      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('HERE ${event.type}');
    });

// Cancel your subscription when done.
    await uploadTask.onComplete;
    streamSubscription.cancel();
    _imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      _uploading = false;
    });
    _createNewRecord(_imageUrl);
    finishUploadingAndClearData();
  }

  void finishUploadingAndClearData() {
    _image = null;
    _formKey.currentState.reset();
  }

  void _createNewRecord(String imageUrl) {
    final CollectionReference todoCollection =
        Firestore.instance.collection('categories');
    todoCollection.add(
        Record(title: _title, image: imageUrl, votes: 1, reference: null)
            .toMap());
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    // Build a Form widget using the _formKey created above.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Text(
          'اضف تصنيفا جديدا',
          style: TextStyle(fontSize: 25),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _getImage(ImageSource.gallery);
              },
              child: Image.asset(
                "images/from_gallery.png",
                width: _width / 2 - 20,
                height: 200,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                _getImage(ImageSource.camera);
              },
              child: Image.asset(
                "images/from_camera.png",
                width: _width / 2 - 20,
                height: 200,
              ),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: _uploading ? CircularProgressIndicator() : null,
              ),
              // Add TextFormFields and RaisedButton here.
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 50, right: 50, bottom: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    hintText: 'ادخل عنوان التصنيف',
                  ),
                  onChanged: (value) {
                    _title = value;
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
              RaisedButton(
                color: Colors.purple,
                //disale this button while uploading
                onPressed: !_uploading
                    ? () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState.validate() &&
                            _image != null) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          _addNewListItem();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('يتم الان اضافة التصنيف')));
                        }
                      }
                    : null,
                child: Text(
                  'اضافة',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
