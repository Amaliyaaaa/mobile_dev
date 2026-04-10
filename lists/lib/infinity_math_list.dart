import 'package:flutter/material.dart';

class InfinityMathList extends StatelessWidget {
  const InfinityMathList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Список элементов"), backgroundColor: Color.fromARGB(255, 76, 102, 175),),
      body: ListView.builder(
        itemBuilder: (context, index) {
          BigInt value = BigInt.from(2).pow(index);
          return ListTile(
            title: Text("2^$index = $value"),
          );
        },
      ),
    );
  }
}
