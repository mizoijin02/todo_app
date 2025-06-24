import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todoapp/models/postal_data.dart';
import 'package:todoapp/utils/logger.dart';

class PostalService {
  static const String _baseUrl = 'http://zipcloud.ibsnet.co.jp/api/search';

  // 郵便番号の入力検証
  bool _isValidZipcode(String zipcode) {
    // // -・スペース・全角スペースなどを削除
    final cleanZipcode =
        zipcode.replaceAll('-', '').replaceAll(' ', '').replaceAll('　', '');
    return RegExp(r'^\d{7}$').hasMatch(cleanZipcode);
  }

  // 郵便番号から住所を検索する機能
  Future<List<PostalData>> searchByZipcode(String zipcode) async {
    try {
      AppLogger.i('郵便番号検索中: $zipcode');

      // 入力検証
      if (!_isValidZipcode(zipcode)) {
        throw Exception('郵便番号は7桁の数字で入力してください\n例：1000001 または 100-0001');
      }

      // ハイフン・スペース・全角スペースなどを削除
      final cleanZipcode =
          zipcode.replaceAll('-', '').replaceAll(' ', '').replaceAll('　', '');

      // ハイフン・スペース・全角スペースなどを削除
      final response = await http
          .get(
            Uri.parse('$_baseUrl?zipcode=$cleanZipcode'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('郵便番号検索に失敗しました (${response.statusCode})');
      }

      //  JSONデータを読み込む
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      if (jsonData['status'] != 200) {
        throw Exception('該当する住所が見つかりませんでした\n郵便番号を確認してください');
      }

      final results = jsonData['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) {
        throw Exception('該当する住所が見つかりませんでした\n郵便番号を確認してください');
      }

      // 住所データを PostalData に変
      final postalDataList = results.map((json) {
        return PostalData(
          zipcode: json['zipcode'] ?? '',
          prefcode: json['prefcode'] ?? '',
          address1: json['address1'] ?? '',
          address2: json['address2'] ?? '',
          address3: json['address3'] ?? '',
          kana1: json['kana1'] ?? '',
          kana2: json['kana2'] ?? '',
          kana3: json['kana3'] ?? '',
        );
      }).toList();

      AppLogger.i('郵便番号検索成功: ${postalDataList.length}件');
      return postalDataList;
    } catch (e, stackTrace) {
      AppLogger.e('郵便番号検索エラー', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
