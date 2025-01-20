import 'package:flutter/material.dart';

class Show extends StatefulWidget {
  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> {
  bool isMenuVisible = false;
  GlobalKey _menuButtonKey = GlobalKey();

  void toggleMenu() {
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
    if (isMenuVisible) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    final RenderBox renderBox =
        _menuButtonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final buttonHeight = renderBox.size.height;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: position.dx - 62,
          top: position.dy + buttonHeight, // 버튼 바로 아래에 위치
          child: Material(
            elevation: 4, // 그림자 효과
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('수정하기', style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('공유하기', style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('삭제하기', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              key: _menuButtonKey, // 버튼에 key 추가
              icon: Icon(Icons.more_vert, color: Colors.black),
              onPressed: toggleMenu,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2024.01.16',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              '제목 2',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '다른 메모를 작성해보았습니다.\n새로운 내용으로 구성된 메모입니다.\n이렇게 여러 줄로 구성할 수 있습니다.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
