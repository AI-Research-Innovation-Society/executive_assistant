import 'package:shared_preferences/shared_preferences.dart';
import '../../bookmark/models/bookmarked_chat.dart';
import '../../bookmark/services/bookmark_service.dart';

class ChatHistoryService {
  static const String _storageKey = 'chat_history';
  static const int maxHistory = 5;

  /// Auto-save or update a chat in history, pruning overflow.
  static Future<void> saveOrUpdate(BookmarkedChat chat) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAll();

    // Update if same id exists, otherwise add
    final idx = existing.indexWhere((c) => c.id == chat.id);
    if (idx != -1) {
      existing[idx] = chat;
    } else {
      existing.insert(0, chat);
    }

    // Prune overflow: keep bookmarked, remove oldest non-bookmarked
    if (existing.length > maxHistory) {
      final bookmarkedIds = await _getBookmarkedIds();
      // Sort newest first for consistent ordering
      existing.sort((a, b) => b.savedAt.compareTo(a.savedAt));

      while (existing.length > maxHistory) {
        // Find the oldest non-bookmarked chat to remove
        final removeIdx = existing.lastIndexWhere((c) => !bookmarkedIds.contains(c.id));
        if (removeIdx != -1) {
          existing.removeAt(removeIdx);
        } else {
          // All are bookmarked, remove the oldest anyway
          existing.removeLast();
        }
      }
    }

    final encoded = existing.map((c) => c.encode()).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  /// Get all history chats, sorted newest first.
  static Future<List<BookmarkedChat>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    final chats = raw.map((s) => BookmarkedChat.decode(s)).toList();
    chats.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return chats;
  }

  /// Delete a chat from history by id.
  static Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAll();
    existing.removeWhere((c) => c.id == id);
    final encoded = existing.map((c) => c.encode()).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  /// Clear all non-bookmarked history.
  static Future<void> clearNonBookmarked() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAll();
    final bookmarkedIds = await _getBookmarkedIds();
    existing.removeWhere((c) => !bookmarkedIds.contains(c.id));
    final encoded = existing.map((c) => c.encode()).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  static Future<Set<String>> _getBookmarkedIds() async {
    final bookmarked = await BookmarkService.getAllChats();
    return bookmarked.map((c) => c.id).toSet();
  }
}
