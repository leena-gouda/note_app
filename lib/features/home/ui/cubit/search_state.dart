class SearchState {
  final List<String> recentSearches;
  final String query;
  final bool showResults; // true after confirming a search (enter / tap recent)

  const SearchState({
    this.recentSearches = const [],
    this.query = '',
    this.showResults = false,
  });

  SearchState copyWith({
    List<String>? recentSearches,
    String? query,
    bool? showResults,
  }) {
    return SearchState(
      recentSearches: recentSearches ?? this.recentSearches,
      query: query ?? this.query,
      showResults: showResults ?? this.showResults,
    );
  }
}
