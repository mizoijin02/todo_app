import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/models/postal_data.dart';
import 'package:todoapp/providers/postal_view_model.dart';

// 郵便番号検索画面
class PostalSearchPage extends ConsumerWidget {
  const PostalSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //現在の郵便番号検索の状態（結果やエラーなど）を取得
    final uiState = ref.watch(postalViewModelProvider);

    //検索フォームと結果表示
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Text('郵便番号検索'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(postalViewModelProvider.notifier).clearResults(),
            icon: const Icon(Icons.delete_rounded),
            tooltip: 'クリア',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 検索フォーム
              const _SearchForm(),
              const SizedBox(height: 16),

              // 結果表示エリア
              Expanded(
                child: _ResultArea(uiState: uiState),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 検索フォームウィジェット
class _SearchForm extends ConsumerStatefulWidget {
  const _SearchForm();

  @override
  ConsumerState<_SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends ConsumerState<_SearchForm> {
  //テキスト入力欄を操作するためのコントローラー
  final _zipcodeController = TextEditingController();

  @override
  void dispose() {
    _zipcodeController.dispose();
    super.dispose();
  }

  // 入力された郵便番号を取得して、検索処理を呼び出し
  void _searchByZipcode() {
    final zipcode = _zipcodeController.text.trim();
    if (zipcode.isNotEmpty) {
      ref.read(postalViewModelProvider.notifier).searchByZipcode(zipcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    //「検索中かどうか」の状態だけを取り出して監視
    final isLoading =
        ref.watch(postalViewModelProvider.select((state) => state.isLoading));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '郵便番号から住所を検索',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 郵便番号検索
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _zipcodeController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      hintText: '1000001 または 100-0001',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mail),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _searchByZipcode(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isLoading ? null : _searchByZipcode,
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('住所検索'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '7桁の郵便番号を入力してください',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// 結果表示エリア
class _ResultArea extends ConsumerWidget {
  const _ResultArea({required this.uiState});

  final PostalUiState uiState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // エラー状態
    if (uiState.errorMessage.isNotEmpty) {
      return _ErrorWidget(
        errorMessage: uiState.errorMessage,
        onRetry: () => ref.read(postalViewModelProvider.notifier).reload(),
      );
    }

    // 読み込み中
    if (uiState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('検索中...'),
          ],
        ),
      );
    }

    // 結果なし
    if (uiState.results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '検索結果がここに表示されます',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              '例: 1000001, 100-0001',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 結果表示
    return _ResultList(results: uiState.results);
  }
}

// エラー表示ウィジェット
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'エラーが発生しました',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text(
              '入力例：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 1000001（東京都千代田区）\n'
              '• 100-0001（ハイフン付きでもOK）\n'
              '• 5400008（大阪府大阪市中央区）',
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('リロード'),
            ),
          ],
        ),
      ),
    );
  }
}

// 結果リスト
class _ResultList extends StatelessWidget {
  const _ResultList({required this.results});

  final List<PostalData> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            '検索結果: ${results.length}件',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return _ResultCard(postal: results[index]);
            },
          ),
        ),
      ],
    );
  }
}

// 各結果カード
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.postal});

  final PostalData postal;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.location_on, color: Colors.blue),
        ),
        title: Text(
          postal.fullAddress,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('郵便番号: ${postal.formattedZipcode}'),
        onTap: () => _showDetailDialog(context, postal),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, PostalData postal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('詳細情報'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow('郵便番号', postal.formattedZipcode),
              _DetailRow('都道府県', postal.address1),
              _DetailRow('市区町村', postal.address2),
              _DetailRow('町域', postal.address3),
              _DetailRow('読み仮名（都道府県）', postal.kana1),
              _DetailRow('読み仮名（市区町村）', postal.kana2),
              _DetailRow('読み仮名（町域）', postal.kana3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}

// 詳細情報行
class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? '（なし）' : value),
          ),
        ],
      ),
    );
  }
}
