import 'package:flutter/material.dart';
import 'todo.dart';

class NextPage extends StatelessWidget {
  const NextPage({
    super.key,
    required this.todoItems,
  });

  final List<Item> todoItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO一覧'),
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoItems[index].text),
            subtitle: Text('カテゴリー:${todoItems[index].category}'),
          );
        },
      ),
    );
  }
}
