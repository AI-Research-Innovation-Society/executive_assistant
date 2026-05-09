import 'package:flutter/material.dart';
import '../../menu/menu_screen.dart';
import '../../vault/vault_screen.dart';

class ChatTopBar extends StatelessWidget {
  final VoidCallback? onBookmark;
  final VoidCallback? onNewChat;

  const ChatTopBar({super.key, this.onBookmark, this.onNewChat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.menu, color: Colors.white, size: 20),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const MenuScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  ),
                );
              },
            ),
          ),
          // Right side buttons
          Row(
            children: [
              // New chat button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit_note, color: Colors.white, size: 20),
                  onPressed: onNewChat,
                ),
              ),
              const SizedBox(width: 8),
              // Bookmark button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
                  onPressed: onBookmark,
                ),
              ),
              const SizedBox(width: 8),
              // Vault button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.lock_outline, color: Colors.white, size: 20),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen()));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
