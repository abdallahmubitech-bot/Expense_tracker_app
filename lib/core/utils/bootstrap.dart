import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/expenses/data/datasources/hive_initializer.dart';

/// Runs the startup sequence before the first frame.
///
/// Any failure is reported to [onError] so the caller can render a recovery
/// screen instead of a white page.
Future<ProviderContainer?> bootstrap({void Function(Object error)? onError}) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await HiveInitializer.initialize();
  } on Object catch (error, stackTrace) {
    debugPrint('Bootstrap failed: $error\n$stackTrace');
    onError?.call(error);
    return null;
  }
  return ProviderContainer();
}
