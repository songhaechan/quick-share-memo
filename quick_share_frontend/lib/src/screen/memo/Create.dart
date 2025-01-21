import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quick_share_frontend/src/controller/MemoController.dart';
import 'package:quick_share_frontend/src/model/MemoModel.dart';
import 'package:quick_share_frontend/src/screen/feed/index.dart';
import 'package:quick_share_frontend/src/screen/note_app.dart';

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  double fontSize = 16.0;
  String fontFamily = '고딕';

  final memoController = Get.put(MemoController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  TextSelection? textSelection;

  TextStyle getTextStyle() {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
      fontFamily: fontFamily,
    );
  }

  _submit() async {
    final result = await memoController.createMemo(
        titleController.text, textController.text);
    if (result) {
      Get.offAll(() => NoteApp());
    }
  }

  void applyStyleToSelectedText() {
    final text = textController.text;
    final selection = textController.selection;

    if (selection.isCollapsed) return;

    final selectedText = text.substring(selection.start, selection.end);
    final beforeText = text.substring(0, selection.start);
    final afterText = text.substring(selection.end);

    textController.text = '$beforeText$selectedText$afterText';
    textController.selection = TextSelection.collapsed(
        offset: beforeText.length + selectedText.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력 부분
            TextField(
              controller: titleController, // 제목 controller 사용
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '제목을 입력하세요',
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold),
                  onPressed: () {
                    setState(() {
                      isBold = !isBold;
                      applyStyleToSelectedText();
                    });
                  },
                  color: isBold ? Colors.blue : Colors.black,
                ),
                SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.format_italic),
                  onPressed: () {
                    setState(() {
                      isItalic = !isItalic;
                      applyStyleToSelectedText();
                    });
                  },
                  color: isItalic ? Colors.blue : Colors.black,
                ),
                SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.format_underline),
                  onPressed: () {
                    setState(() {
                      isUnderline = !isUnderline;
                      applyStyleToSelectedText();
                    });
                  },
                  color: isUnderline ? Colors.blue : Colors.black,
                ),
                SizedBox(width: 12),
                DropdownButton<double>(
                  value: fontSize,
                  items: [12.0, 14.0, 16.0, 18.0]
                      .map((size) => DropdownMenuItem(
                            value: size,
                            child: Text("${size.toInt()}px"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      fontSize = value!;
                      applyStyleToSelectedText();
                    });
                  },
                ),
                SizedBox(width: 12),
                DropdownButton<String>(
                  value: fontFamily,
                  items: ['고딕', '돋움', '붓', '휴먼']
                      .map((font) => DropdownMenuItem(
                            value: font,
                            child: Text(font),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      fontFamily = value!;
                      applyStyleToSelectedText();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: textController, // 내용 입력
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: getTextStyle(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '메모를 입력하세요...',
                ),
                onTap: () {
                  setState(() {
                    textSelection = textController.selection;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        child: FloatingActionButton.extended(
          onPressed: () {
            _submit();
          },
          label: Text(
            '저장',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
