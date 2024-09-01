import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderLoggerModel extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    super.didAddProvider(provider, value, container);

    debugPrint('''
    [ProviderLogger] [$provider] didAddProvider
    [ProviderLogger] [$provider] value: $value
    ''');
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    super.didDisposeProvider(provider, container);

    debugPrint('''
    [ProviderLogger] [$provider] didDisposeProvider
    ''');
  }

  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    super.didUpdateProvider(provider, previousValue, newValue, container);

    debugPrint('''
    [ProviderLogger] [$provider] didUpdateProvider
    [ProviderLogger] [$provider] previousValue: $previousValue
    [ProviderLogger] [$provider] newValue: $newValue
    ''');
  }

  @override
  void providerDidFail(ProviderBase<Object?> provider, Object error,
      StackTrace stackTrace, ProviderContainer container) {
    super.providerDidFail(provider, error, stackTrace, container);

    debugPrint('''
    [ProviderLogger] [$provider] providerDidFail
    [ProviderLogger] [$provider] error: $error
    [ProviderLogger] [$provider] stackTrace: $stackTrace
    ''');
  }
}
