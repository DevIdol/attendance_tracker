# Attendance Tracker

## Tech Stack

- **Flutter**: 3.24.5
- **Architecture**: MVVM + Repository
- **State Management**: Riverpod, FlutterHooks, HooksRiverpod
- **JSON Serialization**: Freezed
- **Navigation**: GoRouter
- **Backend**: Firebase (Authentication, Firestore)
- **Logging**: Logger (for dev)
- **Version Management**: FVM (Flutter Version Management)
- **Other Dependencies**: ConnectivityPlus, Hive (for offline storage) etc...

## Flutter Version

Flutter **3.24.5**

## FVM Setup

Flutter Version Management ([FVM](https://fvm.app/)) is used for version control.
Guide: [FVM Installation](https://github.com/DevIdol/flutter_guide/blob/main/docs/details/02_fvm.md)

### Install Project Version

```bash
fvm install 3.24.5
```

### Use Project Version

```bash
fvm use 3.24.5

fvm flutter pub get

# to add dependencies (Eg: fvm flutter pub add logger)
fvm flutter pub add <package_name>
```

### Launching the app

```bash
#dev
fvm flutter run --dart-define-from-file=config.dev.json

#staging
fvm flutter run --dart-define-from-file=config.staging.json

#prod
fvm flutter run --dart-define-from-file=config.prod.json
```

### Build the app(apk)

```bash
#staging
fvm flutter build apk --dart-define-from-file=config.staging.json

#prod
fvm flutter build apk --dart-define-from-file=config.prod.json
```

## build runnder

```bash
#freezed
fvm flutter pub run build_runner build --delete-conflicting-outputs
or
fvm flutter pub run build_runner build --delete-conflicting-outputs

#reverpod
dart run build_runner watch
or
dart run build_runner watch -d
```

### Deploy rules & indexes

```bash
#dev
firebase use dev

#staging
firebase use staging

#prod
firebase use prod

#deploy
firebase deploy --only firestore:rules

firebase deploy --only firestore:indexes
```

---
