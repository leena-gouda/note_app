import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/home/ui/cubit/search_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchCubit extends Cubit<SearchState> {
  static const _key = 'recent_searches';

  SearchCubit() : super(const SearchState()) {
    _loadSearches();
  }

  Future<void> _loadSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(_key) ?? [];
    emit(state.copyWith(recentSearches: searches));
  }

  /// Called on every keystroke in the search field.
  /// While typing we set showResults=false so UI shows filtered recents.
  void updateQuery(String query) {
    emit(state.copyWith(query: query, showResults: false));
  }

  /// Called when the user confirms (presses Enter) or taps a recent item.
  /// This updates recent list, persists it, and sets showResults=true.
  Future<void> confirmSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    final updated = [...state.recentSearches];
    updated.removeWhere((item) => item.toLowerCase() == q.toLowerCase());
    updated.insert(0, q);
    if (updated.length > 5) updated.removeLast();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, updated);

    emit(state.copyWith(recentSearches: updated, query: q, showResults: true));
  }

  Future<void> removeSearch(String query) async {
    final updated = [...state.recentSearches]..remove(query);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, updated);
    emit(state.copyWith(recentSearches: updated));
  }

  Future<void> clearSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    emit(state.copyWith(recentSearches: []));
  }
}