import 'package:flutter/material.dart';

class FullScreen extends StatefulWidget {
  static final id = "FullScreen";

  @override
  _FullScreenState createState() => _FullScreenState();
}

double _width, _height;

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    final Map args = ModalRoute.of(context).settings.arguments as Map;

    String image = args['image'];
    String title = args['title'];
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.network(
                image,
                width: _width,
                height: _height - 50,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
