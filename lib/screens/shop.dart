import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('xaiy'),
            ],
          ),
        ),
      ),
    );
  }
}
