import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmarked_chat.dart';

class BookmarkService {
  static const String _storageKey = 'bookmarked_chats';

  /// Save a chat to bookmarks.
  static Future<void> saveChat(BookmarkedChat chat) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAllChats();
    existing.add(chat);
    final encoded = existing.map((c) => c.encode()).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  /// Get all bookmarked chats, sorted newest first.
  static Future<List<BookmarkedChat>> getAllChats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    final chats = raw.map((s) => BookmarkedChat.decode(s)).toList();
    chats.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return chats;
  }

  /// Delete a bookmarked chat by its id.
  static Future<void> deleteChat(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAllChats();
    existing.removeWhere((c) => c.id == id);
    final encoded = existing.map((c) => c.encode()).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  /// Check if a chat with the given id is already bookmarked.
  static Future<bool> isBookmarked(String id) async {
    final chats = await getAllChats();
    return chats.any((c) => c.id == id);
  }
}
