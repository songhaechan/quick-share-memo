import 'package:get/get.dart';
import 'package:quick_share_frontend/src/model/MemoModel.dart';
import '../provider/MemoProvider.dart';

class MemoController extends GetxController {
  final memoProvider = Get.put(MemoProvider());
  RxList<MemoModel> feedList = <MemoModel>[].obs;

  // // Memo 조회 (페이징 처리)
  // Future<void> memoIndex({int page = 1}) async {
  //   Map json = await memoProvider.index(page);
  //   List<MemoModel> tmp =
  //       json['data'].map<MemoModel>((m) => MemoModel.parse(m)).toList();
  //   (page == 1) ? feedList.assignAll(tmp) : feedList.addAll(tmp);
  // }

  // Memo 생성
  Future<bool> createMemo(String title, String content) async {
    Map response = await memoProvider.store(title, content);
    if (response['result'] == 'ok') {
      // await memoIndex(); // 생성 후 목록 새로 가져오기
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
    if (response['result'] == 'ok') {
      // await memoIndex(); / / 수정 후 목록 새로 가져오기
      return true;
    } else {
      Get.snackbar('Error', response['message'],
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  // Future<bool> deleteMemo(int id) async {
  //   // Memo 삭제 요청
  //   Map response = await memoProvider.delete(id);

  //   // 서버 응답에서 result 값 확인
  //   if (response['result'] == 'ok') {
  //     // 삭제 후 목록 새로 가져오기
  //     await memoIndex();
  //     return true;
  //   } else {
  //     // 실패 시 에러 메시지 표시
  //     Get.snackbar('Error', response['message'],
  //         snackPosition: SnackPosition.BOTTOM);
  //     return false;
  //   }
  // }
}
