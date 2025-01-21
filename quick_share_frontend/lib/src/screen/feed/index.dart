import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_share_frontend/src/controller/feed_controller.dart';
import 'package:quick_share_frontend/src/model/feed_model.dart';
import 'package:quick_share_frontend/src/screen/feed/feedlistitem.dart';

class FeedIndex extends StatefulWidget {
  @override
  State<FeedIndex> createState() => _FeedIndexState();
}

class _FeedIndexState extends State<FeedIndex> {
  final FeedController feedController = Get.put(FeedController());

  @override
  void initState() {
    super.initState();
    feedController.feedIndex();
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    await feedController.feedIndex();
  }

  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    bool _onNotification(ScrollNotification scrollInfo) {
      if (scrollInfo is ScrollEndNotification &&
          scrollInfo.metrics.extentAfter == 0) {
        feedController.feedIndex(page: ++_currentPage);
        return true;
      }
      return false;
    }

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
                child: Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: _onNotification,
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        itemCount: feedController.feedList.length,
                        itemBuilder: (context, index) {
                          final item = feedController.feedList[index];
                          return FeedListItem(item);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
