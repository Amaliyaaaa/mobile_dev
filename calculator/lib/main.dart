import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyFormPage());
  }
}

class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key});

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _formKey = GlobalKey<FormState>();

  String width = '';
  String height = '';
  String result = 'Задайте параметры';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Калькулятор площади"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ШИРИНА
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("Ширина(мм):", style: TextStyle(fontSize: 18)),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Задайте ширину";
                        }
                        if (int.tryParse(value) == null) {
                          return "Только целое число";
                        }
                        return null;
                      },
                      onChanged: (_) {
                        setState(() {
                          result = "Задайте параметры";
                        });
                      },
                      onSaved: (value) => width = value!,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              /// ВЫСОТА
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("Высота(мм):", style: TextStyle(fontSize: 18)),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Задайте высоту";
                        }
                        if (int.tryParse(value) == null) {
                          return "Только целое число";
                        }
                        return null;
                      },
                      onChanged: (_) {
                        setState(() {
                          result = "Задайте параметры";
                        });
                      },
                      onSaved: (value) => height = value!,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              /// КНОПКА
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // голубая
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // квадратная
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      int w = int.parse(width);
                      int h = int.parse(height);
                      int s = w * h;

                      if (s <= 0) {
                        setState(() {
                          result = "Некорректная площадь";
                        });
                      } else {
                        setState(() {
                          result = "S = $w * $h = $s (мм2)";
                        });
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Вычисление выполнено"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      setState(() {
                        result = "Задайте параметры";
                      });
                    }
                  },
                  child: Text("Вычислить"),
                ),
              ),

              SizedBox(height: 30),

              /// РЕЗУЛЬТАТ
              Center(child: Text(result, style: TextStyle(fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }
}
