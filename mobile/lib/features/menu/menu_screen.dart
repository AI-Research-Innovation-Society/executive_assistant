import 'package:flutter/material.dart';
import '../bookmark/bookmark_screen.dart';
import '../bookmark/models/bookmarked_chat.dart';
import '../bookmark/services/bookmark_service.dart';
import '../chat/services/chat_history_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<BookmarkedChat> _recentChats = [];
  Set<String> _bookmarkedIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final history = await ChatHistoryService.getAll();
    final bookmarked = await BookmarkService.getAllChats();
    setState(() {
      _recentChats = history;
      _bookmarkedIds = bookmarked.map((c) => c.id).toSet();
      _isLoading = false;
    });
  }

  Future<void> _deleteFromHistory(String id) async {
    await ChatHistoryService.delete(id);
    _loadData();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Menu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white54))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Recent chats section header
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 10),
                  child: Text(
                    'Recent Chats',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // Recent chats list
                if (_recentChats.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No recent chats',
                        style: TextStyle(color: Colors.white30, fontSize: 14),
                      ),
                    ),
                  )
                else
                  ..._recentChats.map((chat) => _buildRecentChatItem(chat)),

                const SizedBox(height: 20),

                // Saved Chats navigation
                _buildMenuItem(
                  context,
                  icon: Icons.bookmark_outline,
                  label: 'Saved Chats',
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const BookmarkScreen()));
                    _loadData(); // refresh after returning
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildRecentChatItem(BookmarkedChat chat) {
    final isBookmarked = _bookmarkedIds.contains(chat.id);
    final messageCount = chat.messages.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isBookmarked ? Icons.bookmark : Icons.chat_bubble_outline,
            color: isBookmarked ? Colors.blueAccent : Colors.white24,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              chat.title,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$messageCount msgs • ${_formatDate(chat.savedAt)}',
            style: const TextStyle(color: Colors.white24, fontSize: 10),
          ),
          if (!isBookmarked) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _deleteFromHistory(chat.id),
              child: const Icon(Icons.close, color: Colors.white24, size: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70, size: 22),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white30, size: 20),
        onTap: onTap,
      ),
    );
  }
}
