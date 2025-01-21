import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_share_frontend/src/controller/MemoController.dart';
import 'package:quick_share_frontend/src/screen/memo/Show.dart';
import 'package:quick_share_frontend/src/screen/note_app.dart';

class EditMemo extends StatefulWidget {
  final int id;
  final String title;
  final String content;

  EditMemo({
    required this.id,
    required this.title,
    required this.content,
  });

  @override
  _EditMemoState createState() => _EditMemoState();
}

class _EditMemoState extends State<EditMemo> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  final memoController = Get.put(MemoController());

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> saveMemo() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', '제목을 입력해주세요.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (contentController.text.trim().isEmpty) {
      Get.snackbar('Error', '내용을 입력해주세요.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final result = await memoController.updateMemo(
      widget.id,
      titleController.text.trim(),
      contentController.text.trim(),
    );

    if (result) {
      Get.snackbar('Success', '메모가 성공적으로 수정되었습니다.',
          snackPosition: SnackPosition.BOTTOM);
      Get.to(() => const NoteApp());
    } else {
      Get.snackbar('Error', '메모 수정에 실패하였습니다.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('수정하기'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: saveMemo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              minLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
