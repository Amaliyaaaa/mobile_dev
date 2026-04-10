import 'package:flutter/material.dart';

class InfinityList extends StatelessWidget {
  const InfinityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Список элементов"),backgroundColor: Color.fromARGB(255, 76, 102, 175),),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("строка $index"),
          );
        },
      ),
    );
  }
}
