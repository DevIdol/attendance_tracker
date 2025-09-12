// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$attendanceListNotifierHash() =>
    r'73bbca19f3647336fec1b5f170781f4231d391dc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AttendanceListNotifier
    extends BuildlessNotifier<AttendanceListState> {
  late final String userId;

  AttendanceListState build(
    String userId,
  );
}

/// See also [AttendanceListNotifier].
@ProviderFor(AttendanceListNotifier)
const attendanceListNotifierProvider = AttendanceListNotifierFamily();

/// See also [AttendanceListNotifier].
class AttendanceListNotifierFamily extends Family<AttendanceListState> {
  /// See also [AttendanceListNotifier].
  const AttendanceListNotifierFamily();

  /// See also [AttendanceListNotifier].
  AttendanceListNotifierProvider call(
    String userId,
  ) {
    return AttendanceListNotifierProvider(
      userId,
    );
  }

  @override
  AttendanceListNotifierProvider getProviderOverride(
    covariant AttendanceListNotifierProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'attendanceListNotifierProvider';
}

/// See also [AttendanceListNotifier].
class AttendanceListNotifierProvider
    extends NotifierProviderImpl<AttendanceListNotifier, AttendanceListState> {
  /// See also [AttendanceListNotifier].
  AttendanceListNotifierProvider(
    String userId,
  ) : this._internal(
          () => AttendanceListNotifier()..userId = userId,
          from: attendanceListNotifierProvider,
          name: r'attendanceListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$attendanceListNotifierHash,
          dependencies: AttendanceListNotifierFamily._dependencies,
          allTransitiveDependencies:
              AttendanceListNotifierFamily._allTransitiveDependencies,
          userId: userId,
        );

  AttendanceListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  AttendanceListState runNotifierBuild(
    covariant AttendanceListNotifier notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(AttendanceListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AttendanceListNotifierProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  NotifierProviderElement<AttendanceListNotifier, AttendanceListState>
      createElement() {
    return _AttendanceListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceListNotifierProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AttendanceListNotifierRef on NotifierProviderRef<AttendanceListState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _AttendanceListNotifierProviderElement
    extends NotifierProviderElement<AttendanceListNotifier, AttendanceListState>
    with AttendanceListNotifierRef {
  _AttendanceListNotifierProviderElement(super.provider);

  @override
  String get userId => (origin as AttendanceListNotifierProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
