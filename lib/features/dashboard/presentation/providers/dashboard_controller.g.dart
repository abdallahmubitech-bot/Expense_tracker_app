// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardController)
final dashboardControllerProvider = DashboardControllerProvider._();

final class DashboardControllerProvider
    extends $AsyncNotifierProvider<dashboardController, BudgetSummary> {
  DashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  dashboardController create() => dashboardController();
}

String _$dashboardControllerHash() => r'8f69fadf2a7d2b13aca9e86eac7aa4ab2040cdf2';

abstract class _$DashboardController extends $AsyncNotifier<BudgetSummary> {
  FutureOr<BudgetSummary> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BudgetSummary>, BudgetSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BudgetSummary>, BudgetSummary>,
              AsyncValue<BudgetSummary>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
