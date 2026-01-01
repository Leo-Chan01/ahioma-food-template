import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocalSource {
  factory SearchLocalSource() {
    return _instance;
  }
  SearchLocalSource._();

  static final SearchLocalSource _instance = SearchLocalSource._();
  static const int _maxRecentSearches = 8;

  Future<List<String>> getRecentSearches(SearchMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList(mode.recentSearchesKey) ?? [];
      return searches;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveSearchQuery(String query, SearchMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var searches = prefs.getStringList(mode.recentSearchesKey) ?? [];

      // Remove if already exists
      searches.remove(query);

      // Add to beginning
      searches.insert(0, query);

      // Limit to max items
      if (searches.length > _maxRecentSearches) {
        searches = searches.take(_maxRecentSearches).toList();
      }

      await prefs.setStringList(mode.recentSearchesKey, searches);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> deleteSearchQuery(String query, SearchMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList(mode.recentSearchesKey) ?? [];
      searches.remove(query);
      await prefs.setStringList(mode.recentSearchesKey, searches);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearAllSearches(SearchMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(mode.recentSearchesKey);
    } catch (e) {
      // Handle error silently
    }
  }
}
