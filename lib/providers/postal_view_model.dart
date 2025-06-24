import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoapp/models/postal_data.dart';
import 'package:todoapp/services/postal_service.dart';
import 'package:todoapp/utils/logger.dart';

part 'postal_view_model.g.dart';

// PostalServiceプロバイダー
@riverpod
PostalService postalService(ref) {
  return PostalService();
}

// 郵便番号を検索して、その結果を保存しておく
@riverpod
class PostalViewModel extends _$PostalViewModel {
  // 最初に何も表示していない状態（空のデータ）を作る
  @override
  PostalUiState build() {
    return const PostalUiState();
  }

  // 郵便番号検索機能
  Future<void> searchByZipcode(String zipcode) async {
    if (zipcode.trim().isEmpty) {
      state = state.copyWith(results: [], errorMessage: '');
      return;
    }

    // 読み込みぐるぐるマーク(開始)
    state = state.copyWith(
      isLoading: true,
      errorMessage: '',
      searchQuery: zipcode,
    );

    try {
      AppLogger.i('郵便番号検索開始: $zipcode');
      final postalService = ref.read(postalServiceProvider);

      // 入力した郵便番号で検索して、結果保存
      final results = await postalService.searchByZipcode(zipcode);

      state = state.copyWith(
        results: results,
        isLoading: false,
        errorMessage: '',
      );

      AppLogger.i('郵便番号検索成功: ${results.length}件');
    } catch (e, stackTrace) {
      AppLogger.e('郵便番号検索失敗', error: e, stackTrace: stackTrace);

      state = state.copyWith(
        results: [],
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // リロード（最後の検索を再実行）
  Future<void> reload() async {
    final query = state.searchQuery;
    if (query.isEmpty) return;

    await searchByZipcode(query);
  }

  // 結果をクリア
  void clearResults() {
    state = const PostalUiState();
  }
}
