import 'package:get/get.dart';
import 'package:quick_share_frontend/src/model/MemoModel.dart';
import '../provider/MemoProvider.dart';

class MemoController extends GetxController {
  final memoProvider = Get.put(MemoProvider());
  RxList<MemoModel> feedList = <MemoModel>[].obs;

  // Memo 생성
  Future<bool> createMemo(String title, String content) async {
    Map response = await memoProvider.store(title, content);
    if (response['result'] == 'ok') {
      return true;
    } else {
      Get.snackbar('Error', response['message'],
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  // Memo 수정
  Future<bool> updateMemo(int id, String title, String content) async {
    Map response = await memoProvider.update(id, title, content);
    print(response);
    if (response['result'] == 'ok') {
      return true;
    } else {
      Get.snackbar('Error', response['message'],
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> deleteMemo(int id) async {
    // Memo 삭제 요청
    Map response = await memoProvider.deleteMemo(id);

    if (response['result'] == 'ok') {
      return true;
    } else {
      // 실패 시 에러 메시지 표시
      Get.snackbar('Error', response['message'],
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  // Memo 공유
  Future<bool> shareMemo(int id) async {
    Map response = await memoProvider.share(id);
    if (response['result'] == 'ok') {
      return true;
    } else {
      Get.snackbar('Error', response['message'],
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
