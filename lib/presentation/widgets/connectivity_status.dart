import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/utils.dart';
import '../providers/providers.dart';

class ConnectivityStatus extends ConsumerWidget {
  const ConnectivityStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityNotifierProvider);
    logger.i('Rendering connectivity status: $isConnected');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Icon(
        isConnected ? Icons.wifi : Icons.wifi_off,
        color: isConnected ? AppColors.success : AppColors.error,
      ),
    );
  }
}
