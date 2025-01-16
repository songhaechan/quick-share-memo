import 'package:flutter/material.dart';

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '메모의 이름을 검색',
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            DropdownButton(
              underline: SizedBox(),
              items: [
                DropdownMenuItem(
                  child: Text('이름순', style: TextStyle(color: Colors.black)),
                ),
              ],
              onChanged: (value) {},
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '개인 메모',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                NoteCard(title: '회의 내용 정리', date: '2024.02.15'),
                NoteCard(title: '프로젝트 아이디어', date: '2024.02.14'),
                NoteCard(title: '일정 관리', date: '2024.02.13'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
            label: '설정',
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String date;

  const NoteCard({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
