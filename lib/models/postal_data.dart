import 'package:freezed_annotation/freezed_annotation.dart';

part 'postal_data.freezed.dart';
part 'postal_data.g.dart';

// 郵便番号データ
@freezed
class PostalData with _$PostalData {
  const factory PostalData({
    required String zipcode,
    required String prefcode,
    required String address1,
    required String address2,
    required String address3,
    required String kana1,
    required String kana2,
    required String kana3,
  }) = _PostalData;

  factory PostalData.fromJson(Map<String, dynamic> json) =>
      _$PostalDataFromJson(json);
}

// UIの状態（読み込み中か、エラーか、検索キーワードなど）をまとめて扱う
@freezed
class PostalUiState with _$PostalUiState {
  const factory PostalUiState({
    @Default([]) List<PostalData> results,
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String searchQuery,
  }) = _PostalUiState;
}

extension PostalDataExtension on PostalData {
  // 郵便番号をハイフン付きで表示(1600023 → 160-0023)
  String get formattedZipcode {
    if (zipcode.length == 7) {
      return '${zipcode.substring(0, 3)}-${zipcode.substring(3)}';
    }
    return zipcode;
  }

  String get fullAddress {
    return '$address1$address2$address3';
  }
}
