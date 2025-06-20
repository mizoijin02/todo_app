// todo.dart
import 'package:flutter/material.dart';
import 'nextPage.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

//フレーム更新を管理するTicker機能追加.
class _ToDoPageState extends State<ToDoPage> with TickerProviderStateMixin {
  // TODOのアイテムリスト
  final List<Item> _items = [];
  final TextEditingController _textEditingController = TextEditingController();
  DateTime? _selectedDate;

  late TabController _tabController;
  // 動的なカテゴリーリスト
  List<String> _categories = [
    '日常',
    '買い物',
    '仕事',
  ];

  //各タブ切り替えに　例.日常から買い物に
  String get _nowCategory => _categories[_tabController.index];

  //ここに先ほど入力した値が入る
  Map<String, TextEditingController> _nowCountroller = {
    '日常': TextEditingController(),
    '買い物': TextEditingController(),
    '仕事': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  // タブ追加
  void _addTab() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新しいタブ'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'タブ名を入力'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _categories.add(controller.text);
                  _nowCountroller[controller.text] = TextEditingController();
                  _tabCont         TabController(length: _categories.length, vsync: this);
                });
              }
              Navigator.pop(context);
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }

  // タブ削除
  void _removeTab(String category) {
    if (_categories.length <= 1) return; // 最低1つは残す

    setState(() {
      final index = _categories.indexOf(category);
      _categories.remove(category);
      _nowCountroller[category]?.dispose();
      _nowCountroller.remove(category);

      // そのカテゴリーのアイテムも削除
      _items.removeWhere((item) => item.category == category);

      _tabController.dispose();
      _tabController = TabController(length: _categories.length, vsync: this);
    });
  }

  //追加するボタン押した際の処理
  void _addItem(String category) {
    // 現在のタブのカテゴリー
    final nowCategory = _nowCategory;
    // 現在のタブのコントローラー
    final nowCountroller = _nowCountroller[nowCategory]!;

    if (nowCountroller.text.isNotEmpty) {
      // setStateを呼び出して状態が変化したことをFlutterに伝える。
      setState(() {
        _items.add(
          Item(
            //各テキストと今のタブのカテゴリー
            text: nowCountroller.text,
            dueDate: _selectedDate,
            category: nowCategory,
          ),
        );
      });
      nowCountroller.clear();
      _selectedDate = null;
    }
  }

  // 完了状態に切り替え
  void _toggleCheckbox(int index) {
    setState(() {
      _items[index].isDone = !_items[index].isDone;
    });
  }

  // nextページに遷移
  void _pushNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextPage(todoItems: _items),
      ),
    );
  }

  //全消し
  void _clearAllItems() {
    setState(() {
      _items.clear();
    });
  }

  //1つずつ削除
  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  //期限
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

//期限フォーマット
  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  List<Item> _getCategory(String category) {
    final List<Item> result = [];
    for (final item in _items) {
      if (item.category == category) {
        result.add(item);
      }
    }
    return result;
  }

  //各UI構成処理
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO Page'),
        actions: [
          TextButton(onPressed: _addTab, child: const Text('タブ追加')),
          TextButton(onPressed: _clearAllItems, child: const Text('全削除')),
          TextButton(onPressed: _pushNextPage, child: const Text('一覧')),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _categories.map((category) => _buildTabContent(category)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(_nowCategory),
        child: const Icon(Icons.add),
      ),
    );
  }

  //例ユーザーがテキストフィールドに入力
  Widget _buildTabContent(String category) {
    final categoryItems = _getCategory(category);
    return Column(
      children: [
        //入力を固定化する
        _buildInputRow(category),
        // タブ削除ボタン
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => _removeTab(category),
            child: Text('「$category」タブを削除'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: categoryItems.length,
            itemBuilder: (context, index) {
              //直接アイテムアクセスして
              final item = categoryItems[index];
              final originalIndex = _items.indexOf(item);
              return _buildTodoItem(item, originalIndex);
            },
          ),
        ),
      ],
    );
  }

  // 入力フォームの構築
  Widget _buildInputRow(String category) {
    final controller = _nowCountroller[category]!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          //カテゴリーリスト
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "TODOを入力",
                suffixText: _selectedDate != null
                    ? '期限: ${_formatDate(_selectedDate!)}'
                    : null,
              ),
              onSubmitted: (_) => _addItem(category),
            ),
          ),
          IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today),
          ),
        ],
      ),
    );
  }

  //各アイテムのリストの構成
  Widget _buildTodoItem(Item item, int itemIndex) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: item.isDone,
      onChanged: (value) {
        _toggleCheckbox(itemIndex);
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.text,
            style: TextStyle(
              decoration: item.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: item.isDone ? Colors.black12 : null,
            ),
          ),
          if (item.dueDate != null)
            Text(
              '期限: ${_formatDate(item.dueDate!)}',
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
      secondary: IconButton(
        onPressed: () => _removeItem(itemIndex),
        icon: const Icon(Icons.delete),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    for (final controller in _nowCountroller.values) {
      controller.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }
}

//アイテムの型宣言
class Item {
  String text;
  bool isDone;
  DateTime? dueDate;
  String category;

  Item(
      {required this.text,
      this.isDone = false,
      this.dueDate,
      required this.category});
}
