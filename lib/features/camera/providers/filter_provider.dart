import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filter_model.dart';

class FilterState {
  final PhotoFilter selectedFilter;
  final List<PhotoFilter> availableFilters;

  const FilterState({
    required this.selectedFilter,
    required this.availableFilters,
  });

  FilterState copyWith({
    PhotoFilter? selectedFilter,
    List<PhotoFilter>? availableFilters,
  }) {
    return FilterState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      availableFilters: availableFilters ?? this.availableFilters,
    );
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier()
      : super(FilterState(
          selectedFilter: PhotoFilters.original,
          availableFilters: PhotoFilters.all,
        ));

  void selectFilter(PhotoFilter filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void reset() {
    state = state.copyWith(selectedFilter: PhotoFilters.original);
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
  (ref) => FilterNotifier(),
);
