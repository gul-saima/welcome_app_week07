import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const NameScreen(),
    );
  }
}

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _savedName;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  // Load the saved name when app starts
  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('username');
    });
  }

  // Save the entered name
  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controller.text);
    setState(() {
      _savedName = _controller.text;
    });
  }

  // Reset (clear) the saved name
  Future<void> _resetName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    setState(() {
      _savedName = null;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome App'), backgroundColor: Colors.blueGrey[300],),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _savedName == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveName,
                child: const Text('Save Name'),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, $_savedName!',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resetName,
                child: const Text('Reset Name'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
