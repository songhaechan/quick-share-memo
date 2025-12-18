import 'package:flutter/material.dart';
import 'package:quick_share_frontend/src/screen/auth/Logout.dart';
import 'package:quick_share_frontend/src/screen/memo/Create.dart';

import 'feed/index.dart';

final List<BottomNavigationBarItem> myTabs = [
  BottomNavigationBarItem(
    icon: Icon(Icons.add),
    label: '메모 작성',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.list),
    label: '메모 리스트',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.settings),
    label: '로그아웃',
  ),
];

final List<Widget> myTabItems = [
  Center(child: Create()), // 메모 작성
  FeedIndex(),
  Center(child: LogoutScreen()), // 설정 탭
];

class NoteApp extends StatefulWidget {
  const NoteApp({super.key});

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: myTabs,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: myTabItems,
      ),
    );
  }
}
