import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo.dart';
import 'views/postal_search_page.dart'; // ← 追加

void main() {
  runApp(
    const ProviderScope(
      // Riverpodを有効にする
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TODOページに遷移
  void _pushTodoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ToDoPage(),
      ),
    );
  }

  // 郵便番号検索ページに遷移
  void _pushPostalSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PostalSearchPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '機能を選択してください',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),

            // TODOアプリボタン
            ElevatedButton.icon(
              onPressed: _pushTodoPage,
              icon: const Icon(Icons.checklist),
              label: const Text('TODOアプリ'),
            ),

            const SizedBox(height: 16),

            // 郵便番号検索ボタン
            ElevatedButton.icon(
              onPressed: _pushPostalSearchPage,
              icon: const Icon(Icons.location_on),
              label: const Text('郵便番号検索'),
            ),
          ],
        ),
      ),
    );
  }
}
