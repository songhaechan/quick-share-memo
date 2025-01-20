import 'package:quick_share_frontend/src/model/feed_model.dart';
import 'package:get/get.dart';

import '../provider/feed_provider.dart';

/// 피드 데이터를 관리하는 컨트롤러 클래스
class FeedController extends GetxController {
  /// 피드 API 요청을 처리하는 Provider 인스턴스
  final feedProvider = Get.put(FeedProvider());

  /// 피드 목록을 저장하는 Observable 리스트
  RxList<FeedModel> feedList = <FeedModel>[].obs;

  /// 기존 피드 데이터를 업데이트하는 메서드
  /// [newData] 업데이트할 새로운 피드 데이터
  void updateData(FeedModel newData) {
    final index = feedList.indexWhere((item) => item.id == newData.id);
    if (index != -1) {
      feedList[index] = newData;
    }
  }

  /// 서버로부터 피드 목록을 가져오는 메서드
  /// [page] 가져올 페이지 번호 (기본값: 1)
  Future<void> feedIndex({int page = 1}) async {
    Map json = await feedProvider.getList(page: page);
    List<FeedModel> tmp =
        json['data'].map((item) => FeedModel.parse(item)).toList();
    // 첫 페이지면 목록을 교체하고, 아니면 기존 목록에 추가
    (page == 1) ? feedList.assignAll(tmp) : feedList.addAll(tmp);
  }
}
