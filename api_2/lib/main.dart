import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Обход SSL ошибки
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Загрузка новостей
Future<List<News>> fetchNews(http.Client client) async {
  final url = Uri.parse(
    'https://kubsau.ru/api/getNews.php?key=6df2f5d38d4e16b5a923a6d4873e2ee295d0ac90',
  );

  final response = await client.get(url);

  print('STATUS CODE: ${response.statusCode}');
  print('BODY: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Server error: ${response.statusCode}');
  }

  return compute(parseNews, response.body);
}

// Парсинг JSON
List<News> parseNews(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return (parsed as List).map<News>((json) => News.fromJson(json)).toList();
}

// Модель новости
class News {
  final String title;
  final String text;
  final String date;
  final String image;

  const News({
    required this.title,
    required this.text,
    required this.date,
    required this.image,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: Bidi.stripHtmlIfNeeded(json['TITLE'] ?? ''),
      text: Bidi.stripHtmlIfNeeded(
        json['PREVIEW_TEXT'] ?? json['DETAIL_TEXT'] ?? '',
      ),
      date: json['ACTIVE_FROM'] ?? '',
      image: json['PREVIEW_PICTURE_SRC'] ?? '',
    );
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

// Приложение
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лента новостей КубГАУ',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyHomePage(title: 'Лента новостей КубГАУ'),
    );
  }
}

// Главная страница
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<News>>(
        future: fetchNews(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return const Center(child: Text('Ошибка загрузки новостей'));
          } else if (snapshot.hasData) {
            return NewsList(news: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// Список новостей
class NewsList extends StatelessWidget {
  const NewsList({super.key, required this.news});

  final List<News> news;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        final item = news[index];

        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.image.isNotEmpty) Image.network(item.image),

                const SizedBox(height: 10),

                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(item.text, maxLines: 3, overflow: TextOverflow.ellipsis),

                const SizedBox(height: 8),

                Text(
                  item.date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
