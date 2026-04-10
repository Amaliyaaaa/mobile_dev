import 'package:flutter/material.dart';
import 'simple_list.dart';
import 'infinity_list.dart';
import 'infinity_math_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Лабораторная работа 5"), backgroundColor: const Color.fromARGB(255, 76, 102, 175),),
      body: ListView(
        children: [
          ListTile(
            title: Text("Простой список"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SimpleList()),
              );
            },
          ),
          ListTile(
            title: Text("Бесконечный список"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InfinityList()),
              );
            },
          ),
          ListTile(
            title: Text("Бесконечный список (2^n)"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InfinityMathList()),
              );
            },
          ),
        ],
      ),
    );
  }
}
