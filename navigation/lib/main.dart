import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 Navigation',
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(),
        '/second': (context) => SecondScreen(),
      },
    );
  }
}

// Первый экран
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Первый экран')),
      body: Center(
        child: ElevatedButton(
          child: Text('Перейти на второй экран'),
          onPressed: () async {
            // Переход на второй экран и ожидание результата
            final result = await Navigator.pushNamed(context, '/second');

            if (result != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Вы выбрали: $result')));
            }
          },
        ),
      ),
    );
  }
}

// Второй экран
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Второй экран')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ваш выбор?'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Да'),
              onPressed: () {
                Navigator.pop(context, 'Да');
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Нет'),
              onPressed: () {
                Navigator.pop(context, 'Нет');
              },
            ),
          ],
        ),
      ),
    );
  }
}
