// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryListController)
final categoryListControllerProvider = CategoryListControllerProvider._();

final class CategoryListControllerProvider
    extends $StreamNotifierProvider<categoryListController, List<Category>> {
  CategoryListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryListControllerHash();

  @$internal
  @override
  categoryListController create() => categoryListController();
}

String _$categoryListControllerHash() => r'a3d55adee73dda7bd16682bcc7efa669657b68a0';

abstract class _$CategoryListController extends $StreamNotifier<List<Category>> {
  Stream<List<Category>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Category>>, List<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Category>>, List<Category>>,
              AsyncValue<List<Category>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
