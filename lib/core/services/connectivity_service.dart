import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/utils.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    final isConnected =
        result.isNotEmpty && !result.contains(ConnectivityResult.none);
    logger.i('Network status: ${isConnected ? 'Connected' : 'Disconnected'}');
    return isConnected;
  }

  bool hasConnection(List<ConnectivityResult> results) {
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }
}

final connectivityServiceProvider =
    Provider<ConnectivityService>((ref) => ConnectivityService());
