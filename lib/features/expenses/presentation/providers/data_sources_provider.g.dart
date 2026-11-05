// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_sources_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expenseLocalDataSource)
final expenseLocalDataSourceProvider = ExpenseLocalDataSourceProvider._();

final class ExpenseLocalDataSourceProvider
    extends $FunctionalProvider<ExpenseLocalDataSource, ExpenseLocalDataSource, ExpenseLocalDataSource>
    with $Provider<ExpenseLocalDataSource> {
  ExpenseLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExpenseLocalDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExpenseLocalDataSource create(Ref ref) {
    return expenseLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseLocalDataSource>(value),
    );
  }
}

String _$expenseLocalDataSourceHash() => r'037ca082508f88be36aee57df2ee35b97bc46de7';

@ProviderFor(categoryLocalDataSource)
final categoryLocalDataSourceProvider = CategoryLocalDataSourceProvider._();

final class CategoryLocalDataSourceProvider
    extends $FunctionalProvider<CategoryLocalDataSource, CategoryLocalDataSource, CategoryLocalDataSource>
    with $Provider<CategoryLocalDataSource> {
  CategoryLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<CategoryLocalDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoryLocalDataSource create(Ref ref) {
    return categoryLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryLocalDataSource>(value),
    );
  }
}

String _$categoryLocalDataSourceHash() => r'efa1ba0411e5df80c5d47a4ff8a59a119004d8d0';
