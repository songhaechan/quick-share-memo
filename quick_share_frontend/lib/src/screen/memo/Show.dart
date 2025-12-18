import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위한 패키지 추가
import 'package:quick_share_frontend/src/screen/feed/index.dart';
import 'package:quick_share_frontend/src/screen/memo/Edit.dart';
import 'package:quick_share_frontend/src/controller/MemoController.dart';
import 'package:quick_share_frontend/src/screen/note_app.dart';

class Show extends StatefulWidget {
  final int id; // 메모 ID 추가
  final String title;
  final String content;
  final String createdAt; // 서버에서 받은 날짜를 매개변수로 전달

  Show({
    required this.id, // ID 받기
    required this.title,
    required this.content,
    required this.createdAt,
  });
  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> {
  bool isMenuVisible = false;
  GlobalKey _menuButtonKey = GlobalKey();

  final memoController = Get.put(MemoController());

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
                    onPressed: () {
                      setState(() {
                        isMenuVisible = false;
                      });
                      _removeOverlay();

                      Get.to(() => EditMemo(
                            id: widget.id,
                            title: widget.title,
                            content: widget.content,
                          ));
                    },
                    child: Text('수정하기', style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () async {
                      // 메뉴 닫기
                      setState(() {
                        isMenuVisible = false;
                      });
                      _removeOverlay();

                      // 공유 확인 다이얼로그 표시
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('공유 확인'),
                            content: Text('이 메모를 공유하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false); // 취소
                                },
                                child: Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true); // 확인
                                },
                                child: Text('공유',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          );
                        },
                      );

                      // 사용자가 공유를 확인한 경우 공유 요청 실행
                      if (confirm == true) {
                        final result =
                            await memoController.shareMemo(widget.id);
                        print(result);
                        if (result) {
                          Get.snackbar(
                            '성공',
                            '메모가 공유되었습니다.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          await Get.to(() => NoteApp);
                        }
                      }
                    },
                    child: Text('공유하기', style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () async {
                      // 메뉴 닫기
                      setState(() {
                        isMenuVisible = false;
                      });
                      _removeOverlay();

                      // 삭제 확인 다이얼로그 표시
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('삭제 확인'),
                            content: Text('정말로 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false); // 취소
                                },
                                child: Text('취소'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context, true); // 확인
                                  final result = await memoController
                                      .deleteMemo(widget.id);
                                  print(result);
                                  if (result) {
                                    Get.to(() => NoteApp());
                                  }
                                },
                                child: Text('삭제',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {}
                    },
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
    // 서버에서 받은 createdAt을 DateTime으로 변환
    DateTime date = DateTime.parse(widget.createdAt);
    // 원하는 날짜 형식으로 포맷
    String formattedDate = DateFormat('yyyy.MM.dd').format(date);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back(); // 현재 화면을 종료하고 이전 화면으로 돌아갑니다.
          },
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
            // 서버에서 가져온 날짜를 표시
            Text(
              formattedDate, // 포맷된 날짜 표시
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.content,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
