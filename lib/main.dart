import 'package:flutter/material.dart';
import 'models/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizz&ria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notre pizzéria'),
    );
  }
}
class MyHomePage extends StatelessWidget {
  String title;
  MyHomePage ({required this.title, Key? key}):super(key:key);

  var menus = [
    Menu(1, 'Entrées', 'entree.png', Colors.lightGreen),
    Menu(2, 'Pizzas', 'pizza.png', Colors.redAccent),
    Menu(3, 'Desserts', 'dessert.png', Colors.brown),
    Menu(4, 'Boissons', 'boisson.png', Colors.lightBlue),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: menus.length,
          itemBuilder: (context, index) => _buildRow(menus[index]),
          itemExtent: 180,
      ),
      ),
    );
  }

  _buildRow(Menu menu){
    return Column(
      children: <Widget>[
        Container(
          height: 120,
          child: Image.asset(
            'assets/images/menus/${menu.image}',
            fit: BoxFit.fitWidth,
          ),
        ),
        Text(menu.title)
      ],
    );
  }
}

