
import 'package:flutter/material.dart';

enum TabItem { playlist, guests, chat }

class TabItemData {
  const TabItemData({required this.label, required this.icon});

  final String label;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.playlist: TabItemData(label: 'Playlist', icon: Icons.queue_music_rounded),
    TabItem.guests: TabItemData(label: 'Guests', icon: Icons.people_alt_rounded),
    TabItem.chat: TabItemData(label: 'Chat', icon: Icons.chat),
  };
}