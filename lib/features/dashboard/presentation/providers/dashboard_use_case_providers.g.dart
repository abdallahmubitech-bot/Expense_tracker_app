// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_use_case_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getBudgetSummary)
final getBudgetSummaryProvider = GetBudgetSummaryProvider._();

final class GetBudgetSummaryProvider
    extends $FunctionalProvider<GetBudgetSummary, GetBudgetSummary, GetBudgetSummary>
    with $Provider<GetBudgetSummary> {
  GetBudgetSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getBudgetSummaryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getBudgetSummaryHash();

  @$internal
  @override
  $ProviderElement<GetBudgetSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetBudgetSummary create(Ref ref) {
    return getBudgetSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetBudgetSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetBudgetSummary>(value),
    );
  }
}

String _$getBudgetSummaryHash() => r'cedd3834ff2c40fb656c3b429573d5dafd2aa05c';

@ProviderFor(getCategoryTotals)
final getCategoryTotalsProvider = GetCategoryTotalsProvider._();

final class GetCategoryTotalsProvider
    extends $FunctionalProvider<GetCategoryTotals, GetCategoryTotals, GetCategoryTotals>
    with $Provider<GetCategoryTotals> {
  GetCategoryTotalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCategoryTotalsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCategoryTotalsHash();

  @$internal
  @override
  $ProviderElement<GetCategoryTotals> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCategoryTotals create(Ref ref) {
    return getCategoryTotals(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCategoryTotals value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCategoryTotals>(value),
    );
  }
}

String _$getCategoryTotalsHash() => r'39d4ba0f31f0b337937ee0811b7e8a55b9fdc234';
