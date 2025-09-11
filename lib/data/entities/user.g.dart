// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      profileImageUrl: json['profileImageUrl'] as String?,
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: const NullableTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp?),
      updatedAt: const NullableTimestampConverter()
          .fromJson(json['updatedAt'] as Timestamp?),
      location:
          const GeoPointConverter().fromJson(json['location'] as GeoPoint?),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
      'profileImageUrl': instance.profileImageUrl,
      'fcmTokens': instance.fcmTokens,
      'createdAt':
          const NullableTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const NullableTimestampConverter().toJson(instance.updatedAt),
      'location': const GeoPointConverter().toJson(instance.location),
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.user: 'user',
};
