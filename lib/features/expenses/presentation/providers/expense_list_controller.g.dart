// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expenseListController)
final expenseListControllerProvider = ExpenseListControllerProvider._();

final class ExpenseListControllerProvider
    extends $StreamNotifierProvider<expenseListController, List<Expense>> {
  ExpenseListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseListControllerHash();

  @$internal
  @override
  expenseListController create() => expenseListController();
}

String _$expenseListControllerHash() => r'649f8a15c7c8508e7e38f423b363b5e086177799';

abstract class _$ExpenseListController extends $StreamNotifier<List<Expense>> {
  Stream<List<Expense>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Expense>>, List<Expense>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Expense>>, List<Expense>>,
              AsyncValue<List<Expense>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
