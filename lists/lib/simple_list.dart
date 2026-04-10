import 'package:flutter/material.dart';

class SimpleList extends StatelessWidget {
  const SimpleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Список элементов"), backgroundColor: Color.fromARGB(255, 76, 102, 175),),
      body: ListView(
        children: [
          ListTile(title: Text("0000")),
          Divider(),
          ListTile(title: Text("0001")),
          Divider(),
          ListTile(title: Text("0010")),
        ],
      ),
    );
  }
}
