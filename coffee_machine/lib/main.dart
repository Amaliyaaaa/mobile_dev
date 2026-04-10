import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
      home: const CoffeeMachineHome(),
    );
  }
}

// ==================== МОДЕЛИ ====================

enum CoffeeType { espresso, cappuccino, latte }

extension CoffeeTypeExt on CoffeeType {
  String get name {
    switch (this) {
      case CoffeeType.espresso:
        return 'Эспрессо';
      case CoffeeType.cappuccino:
        return 'Капучино';
      case CoffeeType.latte:
        return 'Латте';
    }
  }

  String get description {
    switch (this) {
      case CoffeeType.espresso:
        return 'Классический итальянский кофе';
      case CoffeeType.cappuccino:
        return 'Кофе с нежной молочной пенкой';
      case CoffeeType.latte:
        return 'Кофе с большим количеством молока';
    }
  }

  int get price {
    switch (this) {
      case CoffeeType.espresso:
        return 100;
      case CoffeeType.cappuccino:
        return 150;
      case CoffeeType.latte:
        return 180;
    }
  }

  int get coffeeBeans => 50;

  int get water => 100;

  int get milk {
    switch (this) {
      case CoffeeType.espresso:
        return 0;
      case CoffeeType.cappuccino:
        return 100;
      case CoffeeType.latte:
        return 250;
    }
  }

  // Получение списка ингредиентов для отображения
  List<Map<String, dynamic>> get ingredients {
    List<Map<String, dynamic>> ingredients = [
      {
        'name': 'Кофе',
        'amount': coffeeBeans,
        'unit': 'г',
        'icon': Icons.coffee,
      },
      {'name': 'Вода', 'amount': water, 'unit': 'мл', 'icon': Icons.water_drop},
    ];

    if (milk > 0) {
      ingredients.add({
        'name': 'Молоко',
        'amount': milk,
        'unit': 'мл',
        'icon': Icons.emoji_food_beverage,
      });
    }

    return ingredients;
  }
}

class CoffeeMachine extends ChangeNotifier {
  int _coffeeBeans = 500;
  int _milk = 1000;
  int _water = 2000;
  int _cash = 0;

  int get coffeeBeans => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;

  set coffeeBeans(int value) {
    _coffeeBeans = value;
    notifyListeners();
  }

  set milk(int value) {
    _milk = value;
    notifyListeners();
  }

  set water(int value) {
    _water = value;
    notifyListeners();
  }

  set cash(int value) {
    _cash = value;
    notifyListeners();
  }

  bool checkResources(CoffeeType coffee) {
    if (_coffeeBeans < coffee.coffeeBeans) return false;
    if (_water < coffee.water) return false;
    if (coffee.milk > 0 && _milk < coffee.milk) return false;
    return true;
  }

  Future<bool> makeCoffee(CoffeeType coffee) async {
    if (!checkResources(coffee)) {
      return false;
    }

    await _heatWater();
    await _brewCoffee();

    if (coffee.milk > 0) {
      await _frothMilk();
      await _mixCoffee();
    }

    _coffeeBeans -= coffee.coffeeBeans;
    _water -= coffee.water;
    if (coffee.milk > 0) {
      _milk -= coffee.milk;
    }
    _cash += coffee.price;
    notifyListeners();

    return true;
  }

  Future<void> _heatWater() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _brewCoffee() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> _frothMilk() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _mixCoffee() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void addResources(int coffee, int milk, int water) {
    _coffeeBeans += coffee;
    _milk += milk;
    _water += water;
    notifyListeners();
  }

  void resetCash() {
    _cash = 0;
    notifyListeners();
  }
}

// ==================== ГЛАВНЫЙ ЭКРАН ====================

class CoffeeMachineHome extends StatefulWidget {
  const CoffeeMachineHome({super.key});

  @override
  State<CoffeeMachineHome> createState() => _CoffeeMachineHomeState();
}

class _CoffeeMachineHomeState extends State<CoffeeMachineHome> {
  final CoffeeMachine _machine = CoffeeMachine();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофемашина'),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          CoffeeScreen(machine: _machine),
          ResourcesScreen(machine: _machine),
          StatsScreen(machine: _machine),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Приготовить',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Ресурсы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Статистика',
          ),
        ],
      ),
    );
  }
}

// ==================== ЭКРАН ПРИГОТОВЛЕНИЯ КОФЕ ====================

class CoffeeScreen extends StatefulWidget {
  final CoffeeMachine machine;
  const CoffeeScreen({super.key, required this.machine});

  @override
  State<CoffeeScreen> createState() => _CoffeeScreenState();
}

class _CoffeeScreenState extends State<CoffeeScreen> {
  bool _isMaking = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Дисплей ресурсов
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _resourceItem(
                  Icons.coffee,
                  'Кофе',
                  widget.machine.coffeeBeans,
                  'г',
                  Colors.brown,
                ),
                _resourceItem(
                  Icons.water_drop,
                  'Вода',
                  widget.machine.water,
                  'мл',
                  Colors.blue,
                ),
                _resourceItem(
                  Icons.emoji_food_beverage,
                  'Молоко',
                  widget.machine.milk,
                  'мл',
                  Colors.amber,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Деньги
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Деньги: ${widget.machine.cash} ₽',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Выберите напиток:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Сетка с кофе
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: CoffeeType.values.map((type) {
              return _coffeeCard(type);
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _resourceItem(
    IconData icon,
    String label,
    int value,
    String unit,
    MaterialColor color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color[700], size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          '$value $unit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color[700],
          ),
        ),
      ],
    );
  }

  Widget _coffeeCard(CoffeeType type) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: _isMaking ? null : () => _makeCoffee(type),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.brown[50]!, Colors.brown[100]!],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Иконка и название
              Icon(
                type == CoffeeType.espresso
                    ? Icons.coffee
                    : type == CoffeeType.cappuccino
                    ? Icons.coffee_maker
                    : Icons.local_cafe,
                size: 48,
                color: Colors.brown[800],
              ),
              const SizedBox(height: 8),
              Text(
                type.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                type.description,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const Divider(height: 16, thickness: 1),

              // Ингредиенты
              const Text(
                'Необходимые ингредиенты:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...type.ingredients.map((ingredient) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        ingredient['icon'],
                        size: 14,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${ingredient['name']}: ${ingredient['amount']} ${ingredient['unit']}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 8),
              const Divider(height: 8, thickness: 1),

              // Цена
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Colors.green,
                    ),
                    Text(
                      '${type.price} ₽',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makeCoffee(CoffeeType type) async {
    setState(() => _isMaking = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Приготовление ${type.name}...'),
            const SizedBox(height: 8),
            Text(
              'Используется: ${type.coffeeBeans}г кофе, ${type.water}мл воды${type.milk > 0 ? ', ${type.milk}мл молока' : ''}',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    final success = await widget.machine.makeCoffee(type);

    if (context.mounted) Navigator.pop(context);

    setState(() => _isMaking = false);

    if (!context.mounted) return;

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Успех! 🎉'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${type.name} готов! Приятного аппетита! ☕'),
              const SizedBox(height: 8),
              Text(
                'Списано: ${type.coffeeBeans}г кофе, ${type.water}мл воды${type.milk > 0 ? ', ${type.milk}мл молока' : ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ошибка ❌'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Недостаточно ресурсов для приготовления!'),
              const SizedBox(height: 8),
              Text(
                'Требуется: ${type.coffeeBeans}г кофе, ${type.water}мл воды${type.milk > 0 ? ', ${type.milk}мл молока' : ''}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

// ==================== ЭКРАН УПРАВЛЕНИЯ РЕСУРСАМИ ====================

class ResourcesScreen extends StatefulWidget {
  final CoffeeMachine machine;
  const ResourcesScreen({super.key, required this.machine});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final TextEditingController _coffeeCtrl = TextEditingController();
  final TextEditingController _milkCtrl = TextEditingController();
  final TextEditingController _waterCtrl = TextEditingController();

  @override
  void dispose() {
    _coffeeCtrl.dispose();
    _milkCtrl.dispose();
    _waterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Управление ресурсами',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Добавьте ингредиенты в кофемашину',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _resourceCard(
            'Кофе',
            widget.machine.coffeeBeans,
            'г',
            Icons.coffee,
            Colors.brown,
            _coffeeCtrl,
          ),
          const SizedBox(height: 12),
          _resourceCard(
            'Вода',
            widget.machine.water,
            'мл',
            Icons.water_drop,
            Colors.blue,
            _waterCtrl,
          ),
          const SizedBox(height: 12),
          _resourceCard(
            'Молоко',
            widget.machine.milk,
            'мл',
            Icons.emoji_food_beverage,
            Colors.amber,
            _milkCtrl,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addResources,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.green[700],
            ),
            child: const Text(
              '➕ Добавить выбранные ресурсы',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _resetResources,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              '🔄 Восстановить все ресурсы (500г кофе, 1000мл молока, 2000мл воды)',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),

          // Справочная информация о рецептах
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📋 Рецепты кофе:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _recipeInfo(CoffeeType.espresso),
                  const SizedBox(height: 8),
                  _recipeInfo(CoffeeType.cappuccino),
                  const SizedBox(height: 8),
                  _recipeInfo(CoffeeType.latte),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _recipeInfo(CoffeeType type) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            child: Icon(
              type == CoffeeType.espresso
                  ? Icons.coffee
                  : type == CoffeeType.cappuccino
                  ? Icons.coffee_maker
                  : Icons.local_cafe,
              size: 20,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${type.name}: ${type.coffeeBeans}г кофе + ${type.water}мл воды${type.milk > 0 ? ' + ${type.milk}мл молока' : ''} = ${type.price}₽',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resourceCard(
    String title,
    int value,
    String unit,
    IconData icon,
    MaterialColor color,
    TextEditingController controller,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color[700], size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Доступно: $value $unit',
                      style: TextStyle(fontSize: 12, color: color[700]),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '$value $unit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Добавить ($unit)',
                suffixText: unit,
                prefixIcon: Icon(icon, size: 20, color: color[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addResources() {
    int coffee = int.tryParse(_coffeeCtrl.text) ?? 0;
    int milk = int.tryParse(_milkCtrl.text) ?? 0;
    int water = int.tryParse(_waterCtrl.text) ?? 0;

    if (coffee == 0 && milk == 0 && water == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите количество ресурсов для добавления'),
        ),
      );
      return;
    }

    widget.machine.addResources(coffee, milk, water);
    _coffeeCtrl.clear();
    _milkCtrl.clear();
    _waterCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ Добавлено: кофе +$coffee г, молоко +$milk мл, вода +$water мл',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetResources() {
    widget.machine.addResources(500, 1000, 2000);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Все ресурсы восстановлены!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// ==================== ЭКРАН СТАТИСТИКИ ====================

class StatsScreen extends StatelessWidget {
  final CoffeeMachine machine;
  const StatsScreen({super.key, required this.machine});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Статистика кофемашины',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Текущее состояние и выручка',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _statCard(
            '💰 Выручка',
            '${machine.cash} ₽',
            Icons.attach_money,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _statCard(
            '☕ Кофейные зерна',
            '${machine.coffeeBeans} г',
            Icons.coffee,
            Colors.brown,
          ),
          const SizedBox(height: 12),
          _statCard(
            '💧 Вода',
            '${machine.water} мл',
            Icons.water_drop,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _statCard(
            '🥛 Молоко',
            '${machine.milk} мл',
            Icons.emoji_food_beverage,
            Colors.amber,
          ),
          const SizedBox(height: 24),

          // Информация о количестве приготовленных порций (примерная)
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Примерное количество порций:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Эспрессо: можно приготовить ~${(machine.coffeeBeans ~/ 50).toString()} порций',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Капучино: можно приготовить ~${(machine.milk ~/ 100).toString()} порций',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Латте: можно приготовить ~${(machine.milk ~/ 250).toString()} порций',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Обнуление кассы'),
                  content: const Text('Вы уверены, что хотите обнулить кассу?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () {
                        machine.resetCash();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('💰 Касса обнулена'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      child: const Text('Обнулить'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.red[700],
            ),
            child: const Text(
              '🧹 Обнулить кассу',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    MaterialColor color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color[700], size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
