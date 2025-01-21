import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_share_frontend/src/model/feed_model.dart';
import 'package:quick_share_frontend/src/provider/feed_provider.dart';

class FeedController extends GetxController {
  RxBool isPersonalMemo = true.obs; // 개인 메모 상태
  RxString sortCriteria = 'name'.obs; // 정렬 기준
  RxList<FeedModel> feedList = <FeedModel>[].obs; // 필터링된 메모 리스트
  RxList<FeedModel> originalFeedList = <FeedModel>[].obs; // 원본 메모 리스트
  RxBool isLoading = false.obs; // 로딩 상태
  RxString searchQuery = ''.obs; // 검색어 상태
  TextEditingController searchController = TextEditingController(); // 검색 입력 상태
  final feedProvider = Get.put(FeedProvider());

  @override
  void onInit() {
    super.onInit();
    feedIndex(); // 초기 데이터 로드
  }

  // 개인/공유 메모 토글
  void toggleMemoList() {
    isPersonalMemo.value = !isPersonalMemo.value;
    if (isPersonalMemo.value == true) {
      feedIndex();
    } else {
      feedIndexOpen();
    }
  }

  // 정렬
  void sortMemos(String criteria) {
    sortCriteria.value = criteria;
    if (criteria == 'name') {
      feedList.sort((a, b) => a.title.compareTo(b.title));
    } else {
      feedList.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  // 검색 및 필터링
  void filterFeeds(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      feedList.assignAll(
        feedList.where((memo) =>
            isPersonalMemo.value ? memo.isPersonal : !memo.isPersonal),
      );
    } else {
      feedList.assignAll(
        feedList.where((memo) =>
            (isPersonalMemo.value ? memo.isPersonal : !memo.isPersonal) &&
            memo.title.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> feedIndexOpen({int page = 1}) async {
    try {
      Map json = await feedProvider.getOpenList(page: page);

      if (json['data'] == null || json['data'] is! List) {
        print('Invalid data format: ${json['data']}');
        return;
      }

      List<FeedModel> tmp = (json['data'] as List)
          .map((item) => FeedModel.parse(item as Map<String, dynamic>))
          .toList();

      (page == 1) ? feedList.assignAll(tmp) : feedList.addAll(tmp);
    } catch (e, stackTrace) {
      print('Error in feedIndex: $e');
      print(stackTrace);
    }
  }

  Future<void> feedIndex({int page = 1}) async {
    try {
      Map json = await feedProvider.getList(page: page);

      if (json['data'] == null || json['data'] is! List) {
        print('Invalid data format: ${json['data']}');
        return;
      }

      List<FeedModel> tmp = (json['data'] as List)
          .map((item) => FeedModel.parse(item as Map<String, dynamic>))
          .toList();

      (page == 1) ? feedList.assignAll(tmp) : feedList.addAll(tmp);
    } catch (e, stackTrace) {
      print('Error in feedIndex: $e');
      print(stackTrace);
    }
  }
}
