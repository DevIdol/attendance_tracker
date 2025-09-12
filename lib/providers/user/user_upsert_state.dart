import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/utils.dart';

part 'user_upsert_state.freezed.dart';

@freezed
class UserUpsertState with _$UserUpsertState {
  const factory UserUpsertState({
    required String id,
    required String email,
    required String name,
    required UserRole role,
    String? profileImageUrl,
    @Default([]) List<String> fcmTokens,
    @GeoPointConverter() GeoPoint? location,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    @Default(false) bool isLoading,
    String? error,
  }) = _UserUpsertState;
}
