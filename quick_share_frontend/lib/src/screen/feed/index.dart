import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_share_frontend/src/controller/feed_controller.dart';
import 'package:quick_share_frontend/src/model/feed_model.dart';

class FeedIndex extends StatelessWidget {
  final FeedController feedController = Get.put(FeedController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (feedController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: feedController.searchController,
                      onChanged: feedController.filterFeeds,
                      decoration: InputDecoration(
                        hintText: '메모의 이름을 검색',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: feedController.toggleMemoList,
                          child: Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                feedController.isPersonalMemo.value
                                    ? '개인 메모'
                                    : '공유받은 메모',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: feedController.sortMemos,
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'name', child: Text('이름순')),
                            PopupMenuItem(value: 'date', child: Text('날짜순')),
                          ],
                          child: Row(
                            children: [
                              Icon(Icons.sort),
                              Obx(() => Text(
                                  feedController.sortCriteria.value == 'name'
                                      ? '이름순'
                                      : '날짜순')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: feedController.feedList.length,
                  itemBuilder: (context, index) {
                    final memo = feedController.feedList[index];
                    return ListTile(
                      title: Text(memo.title),
                      subtitle: Text(memo.date),
                      trailing: memo.isPersonal
                          ? IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                // 팝업 메뉴 표시
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text('수정하기'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            // 수정 동작 추가
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.share),
                                          title: Text('공유하기'),
                                          onTap: () {
                                            Navigator.pop(context);

                                            // 현재 리스트에서 가장 큰 ID를 찾아 +1
                                            int newId = feedController
                                                    .originalFeedList.isNotEmpty
                                                ? feedController
                                                        .originalFeedList
                                                        .map((item) => item.id)
                                                        .reduce((a, b) =>
                                                            a > b ? a : b) +
                                                    1
                                                : 1; // 리스트가 비어 있으면 기본값 1

                                            // 기존 메모 복사 및 새로운 메모 생성
                                            final newMemo = FeedModel.parse({
                                              'id': newId,
                                              'date': memo.date,
                                              'title': memo.title,
                                              'content': memo.content,
                                              'is_personal': 0, // 공유된 메모로 설정
                                            });

                                            // 새로운 메모를 추가하고 UI를 갱신
                                            feedController.originalFeedList
                                                .add(newMemo);

                                            // 새로운 메모를 리스트에 추가
                                            feedController.feedList.assignAll(
                                              feedController.originalFeedList
                                                  .where((item) =>
                                                      feedController
                                                              .isPersonalMemo
                                                              .value
                                                          ? item.isPersonal
                                                          : !item.isPersonal),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('삭제하기'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            // 해당 피드 삭제
                                            feedController.feedList
                                                .removeAt(index);
                                            feedController.originalFeedList
                                                .removeAt(index);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          : null, // is_personal이 0일 경우 trailing 아이콘 숨기기
                      onTap: () {
                        // 메모 클릭 시 동작 추가
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
