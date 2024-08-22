import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a etiqueta de debug
      theme: ThemeData(
        primarySwatch: Colors.green, // Cor principal do estilo Duolingo
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador Flutter'),
        backgroundColor: Colors.green, // Cor do AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Contador: $_counter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Incrementar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor do botão
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _decrementCounter,
              child: const Text('Decrementar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor do botão
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text('Resetar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor do botão
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Ação para o botão Home
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Ação para o botão Search
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Ação para o botão Profile
              },
            ),
          ],
        ),
      ),
    );
  }
}
