import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Общежитие №20',
      home: const DormitoryScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.green),
    );
  }
}

class DormitoryScreen extends StatefulWidget {
  const DormitoryScreen({super.key});

  @override
  State<DormitoryScreen> createState() => _DormitoryScreenState();
}

class _DormitoryScreenState extends State<DormitoryScreen> {
  final String text =
      'Студенческий городок или так называемый кампус Кубанского ГАУ состоит из двадцати общежитий, в которых проживает более 8000 студентов, что составляет 96% от всех нуждающихся. Студенты первого курса обеспечены местами в общежитии полностью. В соответствии с Положением о студенческих общежитиях университета, при поселении между администрацией и студентами заключается договор найма жилого помещения. Воспитательная работа в общежитиях направлена на улучшение быта, соблюдение правил внутреннего распорядка, отсутствия асоциальных явлений в молодежной среде. Условия проживания в общежитиях университетского кампуса полностью отвечают санитарным нормам и требованиям: наличие оборудованных кухонь, душевых комнат, прачечных, читальных залов, комнат самоподготовки, помещений для заседаний студенческих советов и наглядной агитации. С целью улучшения условий быта студентов активно работает система студенческого самоуправления - студенческие советы организуют всю работу по самообслуживанию.';

  // Переменная для отслеживания состояния сердечка
  bool isFavorite = false;

  // Простые функции для демонстрации нажатий
  void _showPhoneMessage() {
    _showSnackBar('Функция звонка: +7 (861) 221-55-55');
  }

  void _showMapMessage() {
    _showSnackBar('Открыть маршрут: Краснодар, ул. Калинина, 13');
  }

  void _showShareMessage() {
    _showDialog(
      'Поделиться',
      'Общежитие №20\n'
          'Краснодар, ул. Калинина, 13\n'
          'Телефон: +7 (861) 221-55-55',
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Функция для переключения состояния сердечка
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // Показываем уведомление о добавлении/удалении из избранного
    _showSnackBar(
      isFavorite ? 'Добавлено в избранное' : 'Удалено из избранного',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Весь контент теперь скроллится
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Зеленая шапка
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.green,
                child: const Text(
                  'Общежития КубГАУ',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Контент (без Expanded)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название общежития с сердечком справа
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Общежитие №20',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        // Сердечко с обработкой нажатия
                        GestureDetector(
                          onTap: _toggleFavorite,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Адрес
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(
                        'Краснодар, ул. Калинина, 13',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),

                    // Зеленые кнопки
                    Row(
                      children: [
                        Expanded(
                          child: _buildGreenButton(
                            'ПОЗВОНИТЬ',
                            onTap: _showPhoneMessage,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildGreenButton(
                            'МАРШРУТ',
                            onTap: _showMapMessage,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildGreenButton(
                            'ПОДЕЛИТЬСЯ',
                            onTap: _showShareMessage,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Divider(thickness: 1, color: Colors.black12),

                    const SizedBox(height: 16),

                    // Текст (без Expanded)
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20), // Отступ перед фото
                    // Фото внизу
                    Container(
                      width: double.infinity,
                      height: 300,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.green.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          'assets/img/1.jpg',
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.green.shade100,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Общежитие №20',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20), // Дополнительный отступ снизу
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreenButton(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
