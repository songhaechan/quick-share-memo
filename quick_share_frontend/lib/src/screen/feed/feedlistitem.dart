import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quick_share_frontend/src/model/feed_model.dart';
import 'package:quick_share_frontend/src/screen/memo/Show.dart';

class FeedListItem extends StatelessWidget {
  final FeedModel item;
  const FeedListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => Show(
            title: item.title, content: item.content, createdAt: item.date));
      },
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 정보 영역
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            item.date,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Divider(
                        color: const Color.fromARGB(255, 144, 144, 144), // 선 색상
                        thickness: 1, // 선 두께
                        indent: 1, // 왼쪽 여백
                        endIndent: 1, // 오른쪽 여백
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
