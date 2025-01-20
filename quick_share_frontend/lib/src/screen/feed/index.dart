import 'package:flutter/material.dart';

class FeedIndex extends StatefulWidget {
  const FeedIndex({super.key});
  @override
  State<FeedIndex> createState() => _FeedIndexState();
}

class _FeedIndexState extends State<FeedIndex> {
  bool isPersonalMemo = true;
  String sortCriteria = 'name'; // 이름순 또는 날짜순 정렬용 변수

  List<Map<String, String>> memos = [
    // 피드(메모) 리스트
  ];

  void toggleMemoList() {
    // 개인 메모 ↔ 공유 메모
    setState(() {
      isPersonalMemo = !isPersonalMemo;
    });
  }

  void sortMemos(String criteria) {
    // 메모 제목으로 정렬
    setState(() {
      sortCriteria = criteria;
      if (criteria == 'name') {
        memos.sort((a, b) => a['title']!.compareTo(b['title']!));
      } else {
        memos.sort((a, b) => b['date']!.compareTo(a['date']!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0, // AppBar 제거
      ),
      body: Column(
        children: [
          // 검색 창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
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
                    // 개인 메모 또는 공유 받은 메모 버튼
                    GestureDetector(
                      onTap: toggleMemoList,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          isPersonalMemo ? '개인 메모' : '공유받은 메모',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // 정렬 버튼
                    PopupMenuButton<String>(
                      onSelected: sortMemos,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'name',
                          child: Text('이름순'),
                        ),
                        PopupMenuItem(
                          value: 'date',
                          child: Text('날짜순'),
                        ),
                      ],
                      child: Row(
                        children: [
                          Icon(Icons.sort),
                          Text(sortCriteria == 'name' ? '이름순' : '날짜순'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 메모 리스트 각 항목 (제목과 날짜)
          Expanded(
            child: ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                final memo = memos[index];
                return ListTile(
                  title: Text(memo['title']!),
                  subtitle: Text(memo['date']!),
                  trailing: IconButton(
                    icon:
                        Icon(Icons.more_vert), // 각 리스트에서 세로 점 3개 눌렀을 때 추가 옵션 팝업
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('수정하기'),
                                  onTap: () {
                                    // 수정하기 동작, 해당 메모의 제목과 내용을 그대로 쓰기 형태로 변경
                                    Navigator.pop(context); // 팝업 닫기
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text('공유하기'),
                                  onTap: () {
                                    // 해당 메모를 공유받은 메모로 상태 변경
                                    Navigator.pop(context); // 팝업 닫기
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('삭제하기'),
                                  onTap: () {
                                    // 삭제하기 동작
                                    Navigator.pop(context); // 팝업 닫기
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  onTap: () {
                    // 해당 메모를 클릭했을 때 메모 읽기 형태로
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
