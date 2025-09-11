// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$attendanceUpsertNotifierHash() =>
    r'85ad0da3cab0aae4c7bb17ef66d0401b5236cdc4';

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

abstract class _$AttendanceUpsertNotifier
    extends BuildlessNotifier<AttendanceUpsertState> {
  late final String userId;

  AttendanceUpsertState build(
    String userId,
  );
}

/// See also [AttendanceUpsertNotifier].
@ProviderFor(AttendanceUpsertNotifier)
const attendanceUpsertNotifierProvider = AttendanceUpsertNotifierFamily();

/// See also [AttendanceUpsertNotifier].
class AttendanceUpsertNotifierFamily extends Family<AttendanceUpsertState> {
  /// See also [AttendanceUpsertNotifier].
  const AttendanceUpsertNotifierFamily();

  /// See also [AttendanceUpsertNotifier].
  AttendanceUpsertNotifierProvider call(
    String userId,
  ) {
    return AttendanceUpsertNotifierProvider(
      userId,
    );
  }

  @override
  AttendanceUpsertNotifierProvider getProviderOverride(
    covariant AttendanceUpsertNotifierProvider provider,
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
  String? get name => r'attendanceUpsertNotifierProvider';
}

/// See also [AttendanceUpsertNotifier].
class AttendanceUpsertNotifierProvider extends NotifierProviderImpl<
    AttendanceUpsertNotifier, AttendanceUpsertState> {
  /// See also [AttendanceUpsertNotifier].
  AttendanceUpsertNotifierProvider(
    String userId,
  ) : this._internal(
          () => AttendanceUpsertNotifier()..userId = userId,
          from: attendanceUpsertNotifierProvider,
          name: r'attendanceUpsertNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$attendanceUpsertNotifierHash,
          dependencies: AttendanceUpsertNotifierFamily._dependencies,
          allTransitiveDependencies:
              AttendanceUpsertNotifierFamily._allTransitiveDependencies,
          userId: userId,
        );

  AttendanceUpsertNotifierProvider._internal(
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
  AttendanceUpsertState runNotifierBuild(
    covariant AttendanceUpsertNotifier notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(AttendanceUpsertNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AttendanceUpsertNotifierProvider._internal(
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
  NotifierProviderElement<AttendanceUpsertNotifier, AttendanceUpsertState>
      createElement() {
    return _AttendanceUpsertNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceUpsertNotifierProvider && other.userId == userId;
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
mixin AttendanceUpsertNotifierRef
    on NotifierProviderRef<AttendanceUpsertState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _AttendanceUpsertNotifierProviderElement extends NotifierProviderElement<
    AttendanceUpsertNotifier,
    AttendanceUpsertState> with AttendanceUpsertNotifierRef {
  _AttendanceUpsertNotifierProviderElement(super.provider);

  @override
  String get userId => (origin as AttendanceUpsertNotifierProvider).userId;
}

String _$attendanceListNotifierHash() =>
    r'73bbca19f3647336fec1b5f170781f4231d391dc';

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
