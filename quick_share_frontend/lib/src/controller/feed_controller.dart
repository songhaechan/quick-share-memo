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
    fetchFeedData(); // 초기 데이터 로드
  }

  // 개인/공유 메모 토글
  void toggleMemoList() {
    isPersonalMemo.value = !isPersonalMemo.value;
    filterFeeds(searchQuery.value);
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

  // 데이터 가져오기
  void fetchFeedData() async {
    isLoading.value = true;
    try {
      // 테스트 데이터
      originalFeedList.assignAll([
        FeedModel.parse({
          'id': 1,
          'date': '2025-01-01',
          'title': '테스트 메모 1',
          'content': '이것은 테스트 메모 1의 내용입니다.',
          'is_personal': 1,
        }),
        FeedModel.parse({
          'id': 2,
          'date': '2025-01-02',
          'title': '공유된 메모 1',
          'content': '공유된 테스트 메모 1의 내용입니다.',
          'is_personal': 0,
        }),
        FeedModel.parse({
          'id': 3,
          'date': '2025-02-01',
          'title': '테스트 메모 2',
          'content': '이것은 테스트 메모 2의 내용입니다.',
          'is_personal': 1,
        }),
        FeedModel.parse({
          'id': 4,
          'date': '2025-01-07',
          'title': '공유된 메모 2',
          'content': '공유된 테스트 메모 2의 내용입니다.',
          'is_personal': 0,
        }),
      ]);
      filterFeeds(''); // 초기 필터링
    } catch (e) {
      print('데이터 로드 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 검색 및 필터링
  void filterFeeds(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      feedList.assignAll(
        originalFeedList.where((memo) =>
            isPersonalMemo.value ? memo.isPersonal : !memo.isPersonal),
      );
    } else {
      feedList.assignAll(
        originalFeedList.where((memo) =>
            (isPersonalMemo.value ? memo.isPersonal : !memo.isPersonal) &&
            memo.title.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> feedIndex({int page = 1}) async {
    Map json = await feedProvider.getList(page: page);
    List<FeedModel> tmp =
        json['data'].map((item) => FeedModel.parse(item)).toList();
    // 첫 페이지면 목록을 교체하고, 아니면 기존 목록에 추가
    (page == 1) ? feedList.assignAll(tmp) : feedList.addAll(tmp);
  }
}
