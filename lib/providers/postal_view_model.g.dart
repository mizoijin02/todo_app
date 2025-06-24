// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postal_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postalServiceHash() => r'3aac9501b948ce139683755fbe6487df0732d460';

/// See also [postalService].
@ProviderFor(postalService)
final postalServiceProvider = AutoDisposeProvider<PostalService>.internal(
  postalService,
  name: r'postalServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postalServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostalServiceRef = AutoDisposeProviderRef<PostalService>;
String _$postalViewModelHash() => r'cbd5039c8e6494ee272abb26114a37951a9e50bd';

/// See also [PostalViewModel].
@ProviderFor(PostalViewModel)
final postalViewModelProvider =
    AutoDisposeNotifierProvider<PostalViewModel, PostalUiState>.internal(
  PostalViewModel.new,
  name: r'postalViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postalViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostalViewModel = AutoDisposeNotifier<PostalUiState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
