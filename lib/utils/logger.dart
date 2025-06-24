// ログ出力用のライブラリをインポート
import 'package:logger/logger.dart';

// アプリ全体でログを出力するためのクラス
class AppLogger {
  // Logger のインスタンスを作成
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      // ログの見た目を設定
      methodCount: 2, // 関数の呼び出し履歴を2つまで表示
      errorMethodCount: 8, // エラー時は8つまで表示
      lineLength: 120, // 1行の最大文字数
      colors: true, // 色付きで表示
      printEmojis: true, // 絵文字を表示
      printTime: true, // 時刻を表示
    ),
  );

  // デバッグ用ログ（開発時の確認用）
  // d = debug の略
  static void d(String message) => _logger.d(message);

  // 情報ログ（正常な動作の記録）
  static void i(String message) => _logger.i(message);

  // 警告ログ（注意が必要だが動作は継続）
  static void w(String message) => _logger.w(message);

  // エラーログ（問題が発生した時）
  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
